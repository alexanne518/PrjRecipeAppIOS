//
//  NavView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-18.
//

import SwiftUI

struct NavView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .toolbarBackground(.visible, for: .tabBar)
                //.toolbarBackground(Color.orange.opacity(0.8), for: .tabBar)
            
            BrowseView()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
            
            PostCreationView()
                .tabItem{
                    Image(systemName: "plus.app.fill")
                    Text("Create")
                }
            
            ProfileView()
                .tabItem{
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

#Preview {
    NavView()
}
