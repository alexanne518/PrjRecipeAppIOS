//
//  HomeView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var auth = AuthService.shared //singleton pattern
    @State private var isLoaded = false
    
    //@EnvironmentObject var authManager : AuthManager
    
    var body: some View {
        
        Text("home page")
    }
}

#Preview {
    HomeView()
}
