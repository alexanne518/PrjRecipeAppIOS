//
//  RecipeDetailView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-21.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    @ObservedObject var auth = AuthService.shared
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 250)
                        .overlay(
                            Image(systemName: "fork.knife.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .foregroundStyle(.white.opacity(0.5))
                        )
                    LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
                }
                .frame(height: 250)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(recipe.category.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            
                            Spacer()
                            
                            if auth.currentUser?.id == recipe.userId {
                                Button {
                                    showDeleteAlert = true
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.red)
                                        .font(.title3)
                                        .padding(8)
                                        .background(.white.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                            
                            HeartButton(recipeId: recipe.id)
                        }
                        
                        Text(recipe.title)
                            .font(.system(size: 32, weight: .bold))
                        
                        HStack(spacing: 20) {
                            Label("\(recipe.timeMinutes) mins", systemImage: "clock")
                            Label("\(recipe.servings) servings", systemImage: "person.2")
                        }
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.title2).bold()
                        
                        let ingredients = recipe.ingredients ?? []
                        
                        if ingredients.isEmpty {
                            Text("No ingredients registered.")
                                .foregroundStyle(.secondary)
                                .italic()
                        } else {
                            ForEach(ingredients, id: \.self) { item in
                                HStack(alignment: .top) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .padding(.top, 6)
                                        .foregroundStyle(.orange)
                                    Text(item)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.title2).bold()
                        
                        let instructions = recipe.instructions ?? []
                        
                        if instructions.isEmpty {
                            Text("No instructions registered.")
                                .foregroundStyle(.secondary)
                                .italic()
                        } else {
                            ForEach(0..<instructions.count, id: \.self) { index in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 28, height: 28)
                                        .background(Circle().fill(.orange))
                                    
                                    Text(instructions[index])
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                }
                .padding()
                .offset(y: -20)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.top, -20)
                )
            }
        }
        .ignoresSafeArea(edges: .top)
        
        .alert("Delete Recipe?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteRecipe()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }
    
    func deleteRecipe() {
        guard let id = recipe.id else { return }
        RecipeService.shared.deleteRecipe(recipeId: id) { error in
            if let error = error {
                print("Error deleting: \(error.localizedDescription)")
            } else {
                dismiss() //Close the view after deleting
            }
        }
    }
}

#Preview {
    RecipeDetailView(
        recipe: Recipe(
            id: "preview1",
            title: "Test Pasta",
            timeMinutes: 30,
            servings: 2,
            category: "Lunch",
            userId: "testUser",
            ingredients: ["Pasta", "Tomato Sauce", "Cheese"],
            instructions: ["Boil water", "Cook pasta", "Eat"]
        )
    )
}
