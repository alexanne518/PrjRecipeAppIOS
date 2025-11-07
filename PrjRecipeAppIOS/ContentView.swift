//
//  ContentView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-01.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var auth = AuthService.shared //singleton pattern
    @State private var isLoaded = false
    
    //@EnvironmentObject var authManager : AuthManager
    
    var body: some View {
        NavigationView{
            Group {
                if !isLoaded {
                    ProgressView()
                        .onAppear(){
                            auth.fetchCurrentAppUser { _ in
                                isLoaded = true
                            }
                        }
                }else if auth.currentUser == nil {
                    LoginView() //switcher
                }else{ //if there is a user currently loged in show thier profile
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
