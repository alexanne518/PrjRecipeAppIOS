//
//  AuthService.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-01.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    //sengelton pattern, not gonna creat an observable object now, ever time we creat an auth service instead of makeing a new authservice we will creat a static authservice and use it everywhere.
    
    static let shared = AuthService()
    
    @Published var currentUser: AppUser? //we created our own user, if we used just User? in model and here then it would be confused if we used firebaseAuth.user or the user model that we created, since the name would be clashing, thats why its called app user
    private let db = Firestore.firestore()
    
    //signup
    func signUp(email: String, password :String, userName: String, completion: @escaping (Result <AppUser, Error>) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password){ //first closure
            result, error in
            
            if let error = error {
                print(error.localizedDescription)
                
                return completion(.failure(error))
            }
            
            guard let user = result?.user else {
                return completion(.failure(SimpleError("Unable to create user"))) //we dont have access to an error object, so we use our own error
            }
            
            //get the uid -> from firebaseAuth in the terms of user, then we map it to the uid int he db, sow e have a 1 to 1 connection with the authticaltion service in firebase you have to creat the conection to the service on your own
            let uid = user.uid // firebaseAuth.user
            
            //creat the appUSer object
            let appUSer = AppUser(id: uid, email: email, userName: userName)
            
            //database query
            do{
                try self.db.collection("users").document(uid).setData(from: appUSer){
                    //second closure
                    error in
                    
                    if let error = error{
                        return completion(.failure(error))
                    }
                    
                    //now i have the user
                    DispatchQueue.main.async{
                        self.currentUser = appUSer
                    }
                }
            }catch{
                completion(.failure(error))
            }
        }
    }
    

    func login (email : String, password: String , completion: @escaping (Result <AppUser, Error>) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password){ result, error in //u log in
            if let error = error{ //if u get an error u get an error message
                completion(.failure(error))
            } else if let user = result?.user{ //if we have the user, we get the appuser
                //if we get the users we need to fetch the app user from the database and set it to the current user
                self.fetchCurrentAppUser { res in //already using the wvar result above so we just gonna use res but its the smae thing
                    switch res {
                    case .success(let appUserObj): //if success try to fetch it up
                        if let appUser = appUserObj{
                            completion(.success(appUser))
                        }else { // if we dont have user object inside creat an empty recorde then push it to firestore
                            //we have somting in auth service but it is a misswatch wit ht e firestore
                            
                            //create an emoty recored
                            let email = result?.user.email ?? "Unknown"
                            let name = result?.user.displayName ?? "Anonymous" //user.display name if part of firebase.user obejct
                            let appUser = AppUser(id: user.uid, email: email, userName: name) //just wont have the user name but ill have the email id tho
                            
                            
                            //need to push it to fireavse
                            do{
                                try self.db.collection("users").document(user.uid).setData(from: appUser){
                                    error in
                                    if let error = error{
                                        completion(.failure(error))
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.currentUser = appUser
                                    }
                                    
                                    completion(.success(appUser))
                                }
                            }catch{
                                completion(.failure(error))
                            }
                            
                            
                            //do a completion, of failsure
                            //completion(.failure(SimpleError("user not found"))) //if we do this the applicatin will crash
                        }
                    case .failure(let failure): //if fetch is falisure show the failure message,
                        completion(.failure(failure)) //when working with the app we can just say error.localizeddescription and it will give u the vaule there
                    }
                }
            }
        }
    }
    
    //fetch user detals
    func fetchCurrentAppUser (completion : @escaping (Result <AppUser?, Error>)-> Void){
        guard let uid = Auth.auth().currentUser?.uid else{
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return completion(.success(nil)) //since the appuser can be optional we make it null
        }//end of guard statment
        
        db.collection("users").document(uid).getDocument{ //collection of users the document is the uid if we have it egt the document for me where we need the snap show and the error
            snap, error in
            
            if let error = error{
                return completion(.failure(error))
            }
            guard let snap = snap else{ //if we have the snap show then good else return the completion
                return completion(.success(nil))
            }
            
            do{
                let user = try snap.data(as: AppUser.self) //destructuring the stream of data or the snap shot we have into the user object (AppUser) its self
                
                //once we get the data
                DispatchQueue.main.async {
                    self.currentUser = user
                }
                completion(.success(user)) //pass in the user itsself
            }catch{
                completion(.failure(error))
            }
        }
    }
    
    //update user details (only user name)
    func updateProfile(userName: String, completion: @escaping (Result <Void, Error>) -> Void){
        //need to get the uid first
        guard let uid = Auth.auth().currentUser?.uid else{
            return completion(.success(()))
        }
        
        //once we get the uid
        db.collection("users").document(uid).updateData(["userName": userName]){
            error in
            if let error = error{
                return completion(.failure(error))
            }else {
                //re frecth the user object, now we have updated ew need the new one to show ion the app
                self.fetchCurrentAppUser { //not explicitaly writing ths user cases, since the fetchuser method is already setting up the user for me
                    _ in
                    completion(.success(()))
                }
            }
        }
    }
    
    
    //sign out
    func signOut () -> Result <Void, Error> {
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return .success(()) //pass in an emty method inside
        }catch{
            print(error.localizedDescription) //not nessisary just to see if we have an error here
            return .failure(error) //error message inside
        }
    }
}


