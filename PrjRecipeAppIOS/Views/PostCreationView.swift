//
//  PostCreationView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-18.
//

import SwiftUI

struct PostCreationView: View {
    @State private var title = ""
    @State private var timeMinutes = ""
    @State private var servings = ""
    @State private var category = "Dinner"
    
    @State private var ingredientsText = ""
    @State private var instructionsText = ""
    
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false
    
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Title (e.g., Pasta)", text: $title)
                    
                    TextField("Time (minutes)", text: $timeMinutes)
                        .keyboardType(.numberPad)
                    
                    TextField("Servings", text: $servings)
                        .keyboardType(.numberPad)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                }
                
                Section(header: Text("Ingredients (One per line)")) {
                    TextEditor(text: $ingredientsText)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Section(header: Text("Instructions (Step by step)")) {
                    TextEditor(text: $instructionsText)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Button("Post Recipe") {
                    saveRecipe()
                }
                .disabled(title.isEmpty || timeMinutes.isEmpty)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(.orange)
                .font(.headline)
            }
            .navigationTitle("New Recipe")
            .alert("Success!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your recipe has been posted.")
            }
        }
    }
    
    func saveRecipe() {
        guard let userId = AuthService.shared.currentUser?.id else {
            errorMessage = "You must be logged in to post."
            return
        }
        
        let ingredientsArray = ingredientsText.components(separatedBy: "\n").filter { !$0.isEmpty }
        let instructionsArray = instructionsText.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        let newRecipe = Recipe(
            title: title,
            timeMinutes: Int(timeMinutes) ?? 0,
            servings: Int(servings) ?? 1,
            category: category,
            userId: userId,
            ingredients: ingredientsArray,
            instructions: instructionsArray
        )
        
        RecipeService.shared.addRecipe(recipe: newRecipe) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                showSuccessAlert = true
            }
        }
    }
}

#Preview {
    PostCreationView()
}
