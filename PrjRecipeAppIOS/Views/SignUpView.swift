//  SignUpView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var userName = ""
    @State private var auth = AuthService.shared
    @State private var errorMessage : String?
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Text("Welcome to Recify").font(.title).fontDesign(.monospaced)
            Image(systemName: "fork.knife.circle.fill").resizable().frame(width: 100, height: 100).foregroundStyle(.orange).padding(.vertical)
            
            Form{
                Section("Sign up to See Our Recipes"){
                    TextField("Username", text:$userName)
                    TextField("Email", text: $email)
                    
                    SecureField("Password", text: $password)
                    
                    SecureField("Confirm Password", text: $passwordConfirm)
                }.padding(.top)
                
                Button("Sign Up"){
                    guard Validators.checkEmail(email) else{
                        self.errorMessage = "Invalid Email"
                        
                        return
                    }
                    guard Validators.isValidPassword(password) else{
                        self.errorMessage = "Invalid Password"
                        return
                    }
                    guard Validators.isValidPassword(passwordConfirm) else{
                        self.errorMessage = "Invalid Confirm Password"
                        return
                    }
                    guard Validators.checkConfirmPwd(password, passwordConfirm) else {
                        self.errorMessage = "Passwords must match"
                        return
                    }
                    /*
                    auth.signUp(email: email, password: password, userName: userName){ result in
                        switch result {
                        case .success(_): self.errorMessage = nil
                        case .failure(let failure): self.errorMessage = failure.localizedDescription
                        }
                        
                    }*/
                    
                    showAlert = true //show alter after sign up is succesfull
                    
                }.disabled(email.isEmpty || password.isEmpty || userName.isEmpty)
                    .frame(width: 350).tint(.orange).font(.title3)
            }.frame(height: 500)
            
            Spacer()
            
            Button(action: {
                dismiss() // This gonna go back to LoginView
            }) {
                Text("Already have an account? Login")
            }
            
            Spacer()
            
        }.alert("Sign up successful", isPresented: $showAlert) {
            Button("OK") {
                dismiss() //closes the sign up page ig
                
                //have to move he sign up here i think 
                auth.signUp(email: email, password: password, userName: userName){ result in
                    switch result {
                    case .success(_): self.errorMessage = nil
                    case .failure(let failure): self.errorMessage = failure.localizedDescription
                    }
                    
                }
            }
        } message: {
            Text("Your account has been created successfully!")
        }
    }
}

#Preview {
    SignUpView()
}
