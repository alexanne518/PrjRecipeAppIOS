//
//  BrowseView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-18.
//

import SwiftUI

struct BrowseView: View {
    @State private var allRecipes: [Recipe] = []
    @State private var searchText = ""
    
    // Helper to calculate which recipes to show
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return allRecipes
        } else {
            return allRecipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                        .background(Circle().fill(Color.white).shadow(color: .orange.opacity(0.3), radius: 2))
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 250, height: 50)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange.opacity(0.5), .yellow.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .overlay {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 18))
                                
                                TextField("Search recipes...", text: $searchText)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange.opacity(0.4), lineWidth: 2)
                        )
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Browse All types of recipes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black).opacity(0.7)
                        .padding(.leading, 4)
                    Spacer()
                }
                .padding(.horizontal)
                
                RoundedRectangle(cornerRadius: 180)
                    .frame(height: 4)
                    .padding(.horizontal)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange.opacity(0.6), .pink.opacity(0.4)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    if allRecipes.isEmpty {
                        Text("Loading recipes...").padding()
                    } else {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 20
                        ) {
                            //loop trough the real data
                            ForEach(filteredRecipes) { recipe in
                                ZStack(alignment: .topTrailing) {
                                    NavigationLink {
                                        RecipeDetailView(recipe: recipe)
                                    } label: {
                                        FeaturedCard(
                                            title: recipe.title,
                                            subtitle: "\(recipe.timeMinutes) min • \(recipe.servings) servings"
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    
                                    HeartButton(recipeId: recipe.id)
                                        .padding([.top, .trailing], 8)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [.white, .pink.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .onAppear {
                loadAllRecipes()
            }
        }
    }
    
    func loadAllRecipes() {
        RecipeService.shared.fetchRecipes { fetchedRecipes in
            DispatchQueue.main.async {
                self.allRecipes = fetchedRecipes
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
    BrowseView()
}
