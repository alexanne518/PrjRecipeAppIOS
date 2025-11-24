//
//  Recipe.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import Foundation
import FirebaseFirestore

struct Recipe: Identifiable, Codable {
    @DocumentID var id: String? // Firebase gives this a unique ID
    var title: String
    var timeMinutes: Int
    var servings: Int
    var category: String
    var userId: String // To know who posted it
    var ingredients: [String]?
    var instructions: [String]?
}
