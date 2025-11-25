//
//  RecipeService.swift
//  PrjRecipeAppIOS
//
//  Created by netblen on 22-11-2025.
//

import Foundation
import FirebaseFirestore
import Combine

class RecipeService: ObservableObject {
    static let shared = RecipeService()
    
    private let db = Firestore.firestore()
    
    //1. Function to ADD a recipe (Create)
    func addRecipe(recipe: Recipe, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("recipes").addDocument(from: recipe) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    //2. Function to fetch SPECIFIC USER recipes
    func fetchRecipes(for userId: String, completion: @escaping ([Recipe]) -> Void) {
        db.collection("recipes")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching user recipes: \(String(describing: error))")
                    completion([])
                    return
                }
                
                let recipes = documents.compactMap { doc -> Recipe? in
                    try? doc.data(as: Recipe.self)
                }
                
                completion(recipes)
            }
    }
    
    //3. Function to fetch ALL recipes
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        db.collection("recipes").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching all recipes: \(String(describing: error))")
                completion([])
                return
            }
            let recipes = documents.compactMap { doc -> Recipe? in
                try? doc.data(as: Recipe.self)
            }
            completion(recipes)
        }
    }
    
    //4. Function to DELETE a recipe
    func deleteRecipe(recipeId: String, completion: @escaping (Error?) -> Void) {
        db.collection("recipes").document(recipeId).delete { error in
            completion(error)
        }
    }
    
}
