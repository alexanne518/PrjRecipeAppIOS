//
//  LoginView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
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
                
                Section("Login to See Our Recipes"){
                    
                    TextField("Email", text: $email)
                    
                    SecureField("Password", text: $password)
                    
                }.padding(.top)
                
                Button("Login"){
                    print("Login clicked")
                    
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
                    auth.login(email: email, password: password) { result in
                        switch result {
                        case .success(let success):
                            self.errorMessage = nil
                        case .failure(let failure):
                            self.errorMessage = failure.localizedDescription
                        }
                    }
                    
                }.disabled(email.isEmpty || password.isEmpty) //wont be able to click the button if the fields are empty
                    .frame(width: 350).tint(.orange)
                    .font(.title3)
                
            }.frame(height: 330)
        
            
            Spacer()
            
            
            NavigationLink(destination: SignUpView()){
                Text("Don't have an account? Sign up")
            }
            
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
