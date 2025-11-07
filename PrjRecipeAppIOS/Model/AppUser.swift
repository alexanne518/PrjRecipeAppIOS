//
//  AppUser.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-02.
//

import Foundation
import FirebaseFirestore

struct AppUser: Identifiable, Codable{
    @DocumentID var id : String? //optional, firebase will set this uuid for us, the id has to be written like "id" or else it will crash
    let email: String //change cant it after
    var userName: String
}
