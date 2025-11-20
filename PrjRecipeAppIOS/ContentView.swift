//
//  ContentView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-01.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var auth = AuthService.shared   // ObservableObject singleton
    @State private var isLoaded = false

    var body: some View {
        NavigationView { 
            Group {
                if !isLoaded {
                    ProgressView()
                        .task {
                            // Fetch once when view appears
                            await fetchUser()
                        }
                } else if auth.currentUser == nil {
                    LoginView()
                        .transition(.opacity.combined(with: .scale))
                } else {
//                    HomeView()
                    NavView()
                        .navigationTitle("Home")
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isLoaded)
            .animation(.easeInOut(duration: 0.2), value: auth.currentUser == nil)
        }
    }

    @MainActor
    private func fetchUser() async {
        await withCheckedContinuation { cont in
            auth.fetchCurrentAppUser { _ in
                isLoaded = true
                cont.resume()
            }
        }
    }
}

#Preview { ContentView() }
