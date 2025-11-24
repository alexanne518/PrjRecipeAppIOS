//
//  ProfileView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-18.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var auth = AuthService.shared
    @State private var errorText: String?
    @State private var myRecipes: [Recipe] = [] //stores the real recipes
    @State private var favoriteRecipes: [Recipe] = []
    
    var body: some View {
        VStack(alignment: .center) {
            
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .center, spacing: 35) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(spacing: 8) {
                        Text(auth.currentUser?.userName ?? "Username")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("\(myRecipes.count) Posts")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(6)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    //Sign Out Button
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 100, height: 40)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .yellow.opacity(0.4)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange.opacity(0.6), lineWidth: 2)
                        )
                        .overlay {
                            Button(role: .destructive) {
                                let result = auth.signOut()
                                if case .failure(let failure) = result {
                                    errorText = failure.localizedDescription
                                } else {
                                    errorText = nil
                                }
                            } label: {
                                Text("Sign Out")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                }
                .padding(.all)
                
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 370, height: 60)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange.opacity(0.6), .pink.opacity(0.4)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange.opacity(0.7), lineWidth: 2)
                                
                                Text("My Recipes")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                if myRecipes.isEmpty {
                    Text("You haven't posted any recipes yet.")
                        .padding()
                        .foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.flexible())], spacing: 20) {
                            ForEach(myRecipes) { r in
                                NavigationLink {
                                    RecipeDetailView(recipe: r)
                                } label: {
                                    FeaturedCard(
                                        title: r.title,
                                        subtitle: "\(r.timeMinutes) min • \(r.servings) servings"
                                    )
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteRecipe(r)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 370, height: 60)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow.opacity(0.5), .orange.opacity(0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange.opacity(0.7), lineWidth: 2)
                                
                                Text("Your Favorites")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.pink).opacity(0.5)
                            }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                if favoriteRecipes.isEmpty {
                    Text("No favorites yet. Go explore!")
                        .padding()
                        .foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.flexible())], spacing: 20) {
                            ForEach(favoriteRecipes) { r in
                                NavigationLink {
                                    RecipeDetailView(recipe: r)
                                } label: {
                                    FeaturedCard(
                                        title: r.title,
                                        subtitle: "\(r.timeMinutes) min • \(r.servings) servings"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
                
            }
        }
        .padding(.all)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.1), .pink.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onAppear {
            loadMyRecipes()
            loadFavorites()
        }
    }
    
    func loadMyRecipes() {
        guard let userId = auth.currentUser?.id else { return }
        
        RecipeService.shared.fetchRecipes(for: userId) { recipes in
            DispatchQueue.main.async {
                self.myRecipes = recipes
            }
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        guard let id = recipe.id else { return }
        
        RecipeService.shared.deleteRecipe(recipeId: id) { error in
            if let error = error {
                print("Error deleting recipe: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.myRecipes.removeAll { $0.id == id }
                    self.loadFavorites()
                }
            }
        }
    }
    
    func loadFavorites() {
        guard let userFavorites = auth.currentUser?.favorites else { return }

        RecipeService.shared.fetchRecipes { allRecipes in
            DispatchQueue.main.async {
                self.favoriteRecipes = allRecipes.filter { recipe in
                    if let id = recipe.id {
                        return userFavorites.contains(id)
                    }
                    return false
                }
            }
        }
    }
}

private struct FeaturedCard: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.secondary.opacity(0.12))
                    .frame(width: 160, height: 120)
                
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.green)
                    .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundColor(.primary)
                .padding(.top, 4)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(6)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(8)
        }
        .frame(width: 160)
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ProfileView()
}
