//
//  SignUpView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var userName = ""
    
    @State private var auth = AuthService.shared
    //@EnvironmentObject var authManager : AuthManager
    
    @State private var errorMessage : String?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            
            Text("Welcome to Recify")
                .font(.title)
                .fontDesign(.monospaced) //idk find a nice font
            
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.orange)
                .padding(.vertical)
            
            
            Form{
                
                Section("Sign up to See Our Recipes"){
                    
                    TextField("Username", text:$userName)
                    
                    TextField("Email", text: $email)
                    
                    SecureField("Password", text: $password)
                    
                }.padding(.top)
                
                Button("Sign Up"){
                    print("Sign Up clicked")
                    
                    //validation
                    
                    //email is the right formate
                    guard Validators.checkEmail(email) else{
                        self.errorMessage = "Invalid Email"
                        return
                    }
                    
                    //password is 6 characters long
                    guard Validators.isValidPassword(password) else{
                        self.errorMessage = "Invalid Password"
                        return
                    }
                    
                    
                    //where we write the sign up
                    auth.signUp(email: email, password: password, userName: userName){ result in
                        switch result {
                        case .success(let success):
                            self.errorMessage = nil
                        case .failure(let failure):
                            self.errorMessage = failure.localizedDescription
                        }
                    }
                    
                }.disabled(email.isEmpty || password.isEmpty || userName.isEmpty) //wont be able to click the button if the fields are empty
                    .frame(width: 350).tint(.orange)
                    .font(.title3)
                
            }.frame(height: 400)
            
            
            Spacer()
            
            
            NavigationLink(destination: SignUpView()){
                Text("Already have an account? Login")
            }
            
            Spacer()
        }
    }
}

#Preview {
    SignUpView()
}
