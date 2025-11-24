//
//  ContentView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-01.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var auth = AuthService.shared
    @State private var isLoaded = false
    
    var body: some View {
        NavigationView {
            Group {
                if !isLoaded {
                    ProgressView().task { await fetchUser() }
                } else if auth.currentUser == nil {
                    NavigationView {
                        LoginView()
                    }
                    .transition(.opacity.combined(with: .scale))
                } else {
                    NavView()
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
