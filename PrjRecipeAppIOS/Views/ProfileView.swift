//
//  ProfileView.swift
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
                    .frame(width: .infinity, height: 120)
                
                
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.green)
                    .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
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
        .frame(width: 190)
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
        .init(title: "Avocado Toast", timeMinutes: 10, servings: 1, category: "Breakfast")
    ]
    
    static let recent: [RItem] = [
        .init(title: "Soup Dumplings", timeMinutes: 30, servings: 2, category: "Lunch"),
        .init(title: "Brownies", timeMinutes: 40, servings: 8, category: "Dessert"),
        .init(title: "Omelette", timeMinutes: 12, servings: 1, category: "Breakfast")
    ]
}

struct ProfileView: View {
    
    @ObservedObject private var auth = AuthService.shared
    @State private var errorText: String?

    var body: some View {
        VStack(alignment: .center) {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                // Profile Header
                HStack(alignment: .center, spacing: 35) {
                    
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle( //made it cute incase we dont jave enough time to change it to have diff options for the users
                            LinearGradient(
                                colors: [.orange, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        
                    
                    VStack(spacing: 8) {
                        Text("Username")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("5 Posts")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(6)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 100, height: 40)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .yellow.opacity(0.4)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange.opacity(0.6), lineWidth: 2)
                        )
                        .overlay {
                            Button(role: .destructive) {
                                let result = auth.signOut()
                                if case .failure(let failure) = result {
                                    errorText = failure.localizedDescription
                                } else {
                                    errorText = nil
                                }
                            } label: {
                                Text("Sign Out")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                }
                .padding(.all)
                
                // Dashboard Section
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 370, height: 60)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange.opacity(0.6), .pink.opacity(0.4)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange.opacity(0.7), lineWidth: 2)
                            
                                Text("Your dashboard")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                // the users secipes scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(
                        rows: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 20
                    ) {
                        ForEach(HomeSampleData.featured) { r in
                            NavigationLink {
                                
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
                .padding()
                
                Spacer()
                
                // users favotires section
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 370, height: 60)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow.opacity(0.5), .orange.opacity(0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange.opacity(0.7), lineWidth: 2)
                            
                                Text("Your Favorites")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.pink).opacity(0.5)
                            }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                // Favorites Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(HomeSampleData.recent) { r in
                            NavigationLink {
                                
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
                    .padding(.vertical, 4)
                }
                .padding()
            }
        }
        .padding(.all)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.1), .pink.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    ProfileView()
}
