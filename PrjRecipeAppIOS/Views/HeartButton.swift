//
//  HeartButton.swift
//  PrjRecipeAppIOS
//
//  Created by netblen on 21-11-2025.
//

import SwiftUI

struct HeartButton: View {
    var recipeId: String?
    @ObservedObject var auth = AuthService.shared
    
    var body: some View {
        Button {
            if let id = recipeId {
                auth.toggleFavorite(recipeId: id)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? .red : .gray)
                .font(.title3)
                .padding(8)
                .background(.white.opacity(0.7))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
    
    var isFavorite: Bool {
        guard let id = recipeId else { return false }
        
        return auth.currentUser?.favorites?.contains(id) ?? false
    }
}

#Preview {
    HeartButton()
}
