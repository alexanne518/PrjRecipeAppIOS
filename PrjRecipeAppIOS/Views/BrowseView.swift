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
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.secondary.opacity(0.12))
                    .frame(width: 170, height: 120)
                
                
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.green)
            }
            
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundColor(.primary)
                .padding(.top, 4)
            
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(6)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(8)
        }
        .frame(width: 170)
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
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
    
    @State var search: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            
            HStack{
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                    .background(Circle().fill(Color.white).shadow(color: .orange.opacity(0.3), radius: 2))
                
                Spacer()
                
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 340, height: 50)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange.opacity(0.5), .yellow.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay {
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.orange)
                                .font(.system(size: 18))
                            
                            TextField("Search recipes...", text: $search)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.orange.opacity(0.4), lineWidth: 2)
                    )
                
                Spacer()
            }
            
            
            HStack{
                Text("Browse All types of recipes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black).opacity(0.7)
                    .padding(.leading, 4)
                Spacer()
            }
            
            
            RoundedRectangle(cornerRadius: 180)
                .frame(height: 4)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange.opacity(0.6), .pink.opacity(0.4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 20
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
            
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.white, .pink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    BrowseView()
}
