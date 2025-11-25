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
    @State private var errorMessage : String?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange.opacity(0.2), .yellow.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 25) {
                VStack(spacing: 15) {
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.orange)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("Welcome to Recify")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.orange)
                }
                .padding(.bottom, 20)
                
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .padding(.horizontal, 20)
                
                // ogin button
                Button(action: {
                    guard Validators.checkEmail(email) else {
                        self.errorMessage = "Please enter a valid email address."
                        return
                    }
                    guard !password.isEmpty else {
                        self.errorMessage = "Password cannot be empty."
                        return
                    }
                    auth.login(email: email, password: password) { result in
                        switch result {
                        case .success(_):
                            self.errorMessage = nil
                        case .failure(let failure):
                            self.errorMessage = failure.localizedDescription
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(email.isEmpty || password.isEmpty ? Color.gray.opacity(0.5) : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .disabled(email.isEmpty || password.isEmpty)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // link to signup
                NavigationLink(destination: SignUpView()){
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
