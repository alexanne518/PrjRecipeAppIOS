import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: AppUser?
    private let db = Firestore.firestore()
    
    //signup
    func signUp(email: String, password :String, userName: String, completion: @escaping (Result <AppUser, Error>) -> Void){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(error))
            }
            guard let user = result?.user else {
                return completion(.failure(SimpleError("Unable to create user")))
            }
            let uid = user.uid
            let appUSer = AppUser(id: uid, email: email, userName: userName)
            
            do{
                try self.db.collection("users").document(uid).setData(from: appUSer){ error in
                    if let error = error{
                        return completion(.failure(error))
                    }
                    completion(.success(appUSer))
                }
            }catch{
                completion(.failure(error))
            }
        }
    }
    func login (email : String, password: String , completion: @escaping (Result <AppUser, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error{
                completion(.failure(error))
            } else if let user = result?.user{
                self.fetchCurrentAppUser { res in
                    switch res {
                    case .success(let appUserObj):
                        if let appUser = appUserObj{
                            completion(.success(appUser))
                        }else {
                            let email = result?.user.email ?? "Unknown"
                            let name = result?.user.displayName ?? "Anonymous"
                            let appUser = AppUser(id: user.uid, email: email, userName: name)
                            
                            do{
                                try self.db.collection("users").document(user.uid).setData(from: appUser){ error in
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
                        }
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
            }
        }
    }
    
    //fetch user details
    func fetchCurrentAppUser (completion : @escaping (Result <AppUser?, Error>)-> Void){
        guard let uid = Auth.auth().currentUser?.uid else{
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return completion(.success(nil))
        }
        
        db.collection("users").document(uid).getDocument{ snap, error in
            if let error = error{
                return completion(.failure(error))
            }
            guard let snap = snap else{
                return completion(.success(nil))
            }
            do{
                let user = try snap.data(as: AppUser.self)
                DispatchQueue.main.async {
                    self.currentUser = user
                }
                completion(.success(user))
            }catch{
                completion(.failure(error))
            }
        }
    }
    
    //update user details
    func updateProfile(userName: String, completion: @escaping (Result <Void, Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else{
            return completion(.success(()))
        }
        db.collection("users").document(uid).updateData(["userName": userName]){ error in
            if let error = error{
                return completion(.failure(error))
            }else {
                self.fetchCurrentAppUser { _ in
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
            return .success(())
        }catch{
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    func toggleFavorite(recipeId: String) {
        guard var user = currentUser, let userId = user.id else { return }
        
        //Initialize the array if it is nil
        var favorites = user.favorites ?? []
        
        if favorites.contains(recipeId) {
            favorites.removeAll { $0 == recipeId }
            db.collection("users").document(userId).updateData([
                "favorites": FieldValue.arrayRemove([recipeId])
            ])
        } else {
            favorites.append(recipeId)
            db.collection("users").document(userId).updateData([
                "favorites": FieldValue.arrayUnion([recipeId])
            ])
        }
        user.favorites = favorites
        self.currentUser = user
    }
}
