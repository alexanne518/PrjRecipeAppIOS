//
//  FavoritesView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-19.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var auth = AuthService.shared
    @State private var favoriteRecipes: [Recipe] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                if favoriteRecipes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundStyle(.gray)
                        Text("No Favorites Yet")
                            .font(.title2).bold()
                        Text("Go browse and like some recipes!")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 50)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(favoriteRecipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                FavCard(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("My Favorites")
            .onAppear {
                loadFavorites()
            }
        }
    }
    
    func loadFavorites() {
        //1. Get the user list of favorite
        guard let userFavorites = auth.currentUser?.favorites else { return }
        
        //2. Fetch ALL recipes, but only keep the ones that are in the list
        RecipeService.shared.fetchRecipes { allRecipes in
            DispatchQueue.main.async {
                self.favoriteRecipes = allRecipes.filter { recipe in
                    //Only keep if the recipe ID is in the user favorites list
                    if let id = recipe.id {
                        return userFavorites.contains(id)
                    }
                    return false
                }
            }
        }
    }
}

private struct FavCard: View {
    let recipe: Recipe
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.1))
                .frame(height: 120)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                )
            Text(recipe.title).font(.headline).lineLimit(1)
        }
    }
}

#Preview {
    FavoritesView()
}
