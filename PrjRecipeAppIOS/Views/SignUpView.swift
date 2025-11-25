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
    @State private var tempUser: AppUser?
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange.opacity(0.2), .pink.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20){
                VStack {
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.orange)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Text("Create Account")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.primary)
                }
                .padding(.top, 20)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                VStack(spacing: 15) {
                    TextField("Username", text:$userName)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Confirm Password", text: $passwordConfirm)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 25)
                
                // Button with Loading Logic
                Button(action: {
                    guard Validators.checkEmail(email) else{
                        self.errorMessage = "Invalid Email Format"
                        return
                    }
                    guard Validators.isValidPassword(password) else{
                        self.errorMessage = "Password must be at least 6 characters"
                        return
                    }
                    guard Validators.checkConfirmPwd(password, passwordConfirm) else {
                        self.errorMessage = "Passwords do not match"
                        return
                    }
                    isLoading = true
                    errorMessage = nil
                    
                    auth.signUp(email: email, password: password, userName: userName){ result in
                        
                        DispatchQueue.main.async {
                            isLoading = false // Stop spinner
                            
                            switch result {
                            case .success(let user):
                                self.errorMessage = nil
                                self.tempUser = user
                                self.showAlert = true
                            case .failure(let failure):
                                //If firebase fails show that error
                                self.errorMessage = failure.localizedDescription
                            }
                        }
                    }
                }) {
                    ZStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                        }
                    }.frame(maxWidth: .infinity)
                    .padding()
                    .background((isLoading || email.isEmpty || password.isEmpty || userName.isEmpty) ? Color.gray.opacity(0.5) : Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 5)
                }.disabled(isLoading || email.isEmpty || password.isEmpty || userName.isEmpty)
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    dismiss() //Go back to Login
                }) {
                    HStack {
                        Text("Already have an account?")
                            .foregroundStyle(.secondary)
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
                .padding(.bottom, 10)
            }
        }
        //The alert dismisses the view to let them log in
        .alert("Sign Up Successful", isPresented: $showAlert) {
            Button("OK") {
                //redirect to Homepage when clicked
                if let user = tempUser {
                    auth.currentUser = user
                }
            }
        } message: {
            Text("Your account has been created. Click OK to proceed to the home page.")
        }
    }
}

#Preview {
    SignUpView()
}
