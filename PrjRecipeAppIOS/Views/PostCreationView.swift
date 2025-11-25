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
    @State private var showValidationError = false
    @State private var validationErrors: [String] = []

    /* gonna do it another way
    private var isFormValidInput: Bool {
        if (!title.isEmpty && !timeMinutes.isEmpty && !servings.isEmpty && !ingredientsText.trimmingCharacters(in: .whitespaces).isEmpty && !instructionsText.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            true
        }else {
            false
        }
    }*/
    
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack"]
    
    var body: some View {
        NavigationView {
            
            Form {
                
                
                if !validationErrors.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(validationErrors, id: \.self) { error in
                                HStack(alignment: .top) {
                                    
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Recipe Details")) {
                    TextField("Title (e.g., Pasta)", text: $title)
                        .onChange(of: title) { validateForm()}
                    
                    TextField("Time (minutes)", text: $timeMinutes)
                        .keyboardType(.numberPad)
                        .onChange(of: timeMinutes) { validateForm()}

                    
                    TextField("Servings", text: $servings)
                        .keyboardType(.numberPad)
                        .onChange(of: servings) { validateForm()}

                    
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
                        .onChange(of: ingredientsText) { validateForm()}
                }
                
                
                Section(header: Text("Instructions (Step by step)")) {
                    TextEditor(text: $instructionsText)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .onChange(of: instructionsText) { validateForm()}
                }
                
                Button("Post Recipe") {
                    if validateForm() {
                        saveRecipe()
                        showSuccessAlert = true
                        showValidationError = false
                    } else {
                        showValidationError = true
                        showSuccessAlert = false
                    }
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
            //fail
            .alert("Missing Information", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill in all required fields before posting.")
            }
        }
    }
    
    func validateForm() -> Bool {
            validationErrors.removeAll()
            
            
            if title.isEmpty {
                validationErrors.append("Recipe title is required")
            }
            
        
            if timeMinutes.isEmpty {
                validationErrors.append("Cooking time is required")
            } else if Int(timeMinutes) ?? 0 <= 0 {
                validationErrors.append("Cooking time must be greater than 0")
            }
            
            if servings.isEmpty {
                validationErrors.append("Number of servings is required")
            } else if Int(servings) ?? 0 <= 0 {
                validationErrors.append("Servings must be greater than 0")
            }
        
            
            let trimmedIngre = ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedIngre.isEmpty {
                validationErrors.append("At least one ingredient is required")
            }
            
        
        
            let trimmedInst = instructionsText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedInst.isEmpty {
                validationErrors.append("Instructions are required")
            }
            
            return validationErrors.isEmpty
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
