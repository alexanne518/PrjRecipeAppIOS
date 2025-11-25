//
//  HomeView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import SwiftUI

struct HomeView: View {
    //savs recipes created by the user
    @State private var allRecipes: [Recipe] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome to Recify")
                            .font(.largeTitle).bold()
                        Text("Discover, cook, and share your favourite recipes.")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        NavigationLink {
                            BrowseView()
                        } label: {
                            HomeTile(icon: "book.pages", title: "Browse")
                        }
                        
                        NavigationLink {
                            PostCreationView()
                        } label: {
                            HomeTile(icon: "plus.circle", title: "Create")
                        }
                        
                        NavigationLink {
                            FavoritesView()
                        } label: {
                            HomeTile(icon: "heart", title: "Favorites")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Featured")
                            .font(.headline)
                        
                        if allRecipes.isEmpty {
                            Text("Loading recipes...")
                                .foregroundStyle(.secondary)
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    //shows the first 5 featured
                                    ForEach(allRecipes.prefix(5)) { r in
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
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent")
                            .font(.headline)
                        
                        LazyVStack(spacing: 8) {
                            //shows all the recipes
                            ForEach(allRecipes) { r in
                                NavigationLink {
                                    RecipeDetailView(recipe: r)
                                } label: {
                                    RecipeRow(
                                        title: r.title,
                                        meta: "\(r.timeMinutes) min • \(r.servings) servings",
                                        tag: r.category
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        RecipeService.shared.fetchRecipes { fetchedRecipes in
            DispatchQueue.main.async {
                self.allRecipes = fetchedRecipes
            }
        }
    }
}

private struct HomeTile: View {
    let icon: String
    let title: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.secondary.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct FeaturedCard: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.12))
                .frame(width: 240, height: 120)
                .overlay(
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange.opacity(0.8))
                )
            Text(title)
                .font(.subheadline).bold()
                .lineLimit(2)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 240, alignment: .leading)
    }
}

private struct RecipeRow: View {
    let title: String
    let meta: String
    let tag: String
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary.opacity(0.12))
                .frame(width: 64, height: 64)
                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).lineLimit(1)
                Text(meta).font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer()
            Text(tag)
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Capsule().stroke(.secondary.opacity(0.5), lineWidth: 1))
                .foregroundStyle(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.secondary.opacity(0.15))
        )
    }
}

#Preview {
    HomeView()
}
