//
//  RecipeDetailView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-21.
//

import SwiftUI

struct RecipeDetailView: View {
    let title: String
    let timeMinutes: Int
    let servings: Int
    let category: String
    
// hardcoded currently
    let sampleIngredients = [
        "1 pack of Pasta",
        "2 cups Tomato Sauce",
        "1 tbsp Olive Oil",
        "Salt & Pepper to taste",
        "Fresh Basil"
    ]
    
    let sampleInstructions = [
        "Boil a large pot of salted water.",
        "Add pasta and cook until al dente.",
        "Heat the sauce in a separate pan.",
        "Drain pasta and mix with sauce.",
        "Serve hot with fresh basil."
    ]

    @State private var isFavorite: Bool = false

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
                            Text(category.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Spacer()
                            Button {
                                isFavorite.toggle()
                            } label: {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundStyle(isFavorite ? .red : .gray)
                                    .font(.title2)
                            }
                        }
                        Text(title)
                            .font(.system(size: 32, weight: .bold))
                        
                        HStack(spacing: 20) {
                            Label("\(timeMinutes) mins", systemImage: "clock")
                            Label("\(servings) servings", systemImage: "person.2")
                        }
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.title2).bold()
                        
                        ForEach(sampleIngredients, id: \.self) { item in
                            HStack(alignment: .top) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .padding(.top, 6)
                                    .foregroundStyle(.orange)
                                Text(item)
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.title2).bold()
                        
                        ForEach(0..<sampleInstructions.count, id: \.self) { index in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(.orange))
                                
                                Text(sampleInstructions[index])
                                    .fixedSize(horizontal: false, vertical: true)
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
    }
}

#Preview {
    RecipeDetailView(
        title: "Spaghetti Bolognese",
        timeMinutes: 30,
        servings: 4,
        category: "Lunch"
    )
}
