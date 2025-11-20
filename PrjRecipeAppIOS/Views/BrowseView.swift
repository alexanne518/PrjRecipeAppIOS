//
//  BrowseView.swift
//  PrjRecipeAppIOS
//
//  Created by Macbook on 2025-11-18.
//

import SwiftUI

private struct FeaturedCard: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.12))
                .frame(width: 170, height: 120)
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
        .frame(width: 190)
    }
}

private struct RItem: Identifiable {
    let id = UUID()
    let title: String
    let timeMinutes: Int
    let servings: Int
    let category: String //this needs to be an enum
}

private enum HomeSampleData {
    static let featured: [RItem] = [
        .init(title: "Spaghetti Bolognese", timeMinutes: 30, servings: 3, category: "Dinner"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast"),
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast")

    ]

}


struct BrowseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            
            
            Image(systemName: "person.crop.circle")
                .font(.title)
            
            Text("Browse All types of recipes")
            
            RoundedRectangle(cornerRadius: 180)
                .frame(width: .infinity, height: 5)
                .foregroundStyle(.gray).opacity(0.6)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 12
                ) {
                    ForEach(HomeSampleData.featured) { r in
                        NavigationLink {
                            // replace with recipe detail view
                            Text("Detail for \(r.title)")
                        } label: {
                            FeaturedCard(
                                title: r.title,
                                subtitle: "\(r.timeMinutes) min • \(r.servings) servings"
                            )
                            
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
        }.padding()
        
    }
}

#Preview {
    BrowseView()
}
