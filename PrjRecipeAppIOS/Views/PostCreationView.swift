//
//  PostCreationView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-18.
//

import SwiftUI

struct PostCreationView: View {
    // dynamic
    @State private var title: String = ""
    @State private var category: String = "Dinner"
    @State private var prepTime: Int = 30
    @State private var servings: Int = 2
    @State private var ingredients: String = ""
    @State private var instructions: String = ""
    
    // pop-up when saved
    @State private var showSuccessAlert = false
    
    let categories = ["Breakfast", "Lunch", "Dessert", "Snack"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Button {
                        // todo: photopciker
                        print("Tapped add photo")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(height: 200)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.largeTitle)
                                Text("Add Cover Photo")
                                    .font(.footnote)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recipe Details")
                            .font(.headline)
                        
                        // title
                        TextField("Recipe Title (e.g. Spaghetti)", text: $title)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.secondary.opacity(0.3))
                            )
                        
                        // category picker
                        HStack {
                            Text("Category")
                            Spacer()
                            Picker("Category", selection: $category) {
                                ForEach(categories, id: \.self) { cat in
                                    Text(cat).tag(cat)
                                }
                            }
                            .tint(.orange)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(10)
                    }
                    
                    HStack(spacing: 12) {
                        VStack {
                            Text("Time")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(prepTime) min")
                                .font(.headline)
                            Stepper("", value: $prepTime, in: 5...180, step: 5)
                                .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(10)
                        VStack {
                            Text("Servings")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(servings) ppl")
                                .font(.headline)
                            Stepper("", value: $servings, in: 1...20)
                                .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.headline)
                        
                        TextEditor(text: $ingredients)
                            .frame(height: 100)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text("Instructions")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        TextEditor(text: $instructions)
                            .frame(height: 100)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    Button {
                        // Action to save recipe
                        print("Recipe Saved: \(title)")
                        showSuccessAlert = true
                    } label: {
                        Text("Post your Recipe")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
            }
            .navigationTitle("Create a Recipe")
            .alert("Recipe Posted!", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your recipe '\(title)' has been added successfully.")
            }
        }
    }
}

#Preview {
    PostCreationView()
}
