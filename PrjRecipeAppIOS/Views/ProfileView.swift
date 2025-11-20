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
    @State private var errorText : String?


    var body: some View {
        VStack(alignment: .center){
            
            ScrollView(.vertical, showsIndicators: false){
                
                HStack(alignment: .center, spacing: 35){
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.horizontal)
                    VStack{
                        Text("Username")
                            .bold(true)
                        
                        Text("5 Posts") //get coiunt from db
                    }
                    
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 100, height: 40)
                        .overlay{
                            
                            Button(role: .destructive) {
                                let result = auth.signOut()
                                if case .failure(let failure) = result { //when we have the faliure the current user is set to null and will automatically go back to the login page
                                    errorText = failure.localizedDescription
                                }else {
                                    errorText = nil
                                }
                            } label: {
                                Text("Sign Out").foregroundStyle(.white)
                            }
                        }

                }.padding(.all)
                
                VStack(alignment: .center){
                    HStack{
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 370, height: 60)
                            .foregroundStyle(.orange).opacity(0.8)
                            .overlay{
                                Text("Your dashboard")
                                
                            }
                        
                        Spacer()
                    }
                    
                }.padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHGrid(
                        rows: [
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
                }.padding()
                Spacer()
                
                VStack(alignment: .center){
                    HStack{
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 370, height: 60)
                            .foregroundStyle(.yellow).opacity(0.5)
                            .overlay{
                                Text("Your Favories")
                                
                                
//                                idk if yall wanna do a faorites page
//                                Spacer()
//                                
//                                NavigationLink(destination: FavoritesView()){
//                                    VStack{
//                                        Image(systemName: "ellipsis.circle.fill")
//                                            .foregroundStyle(.white)
//                                            .font(.title)
//                                        
//                                        Text("view all").foregroundStyle(.white)
//                                    }
//                                }.buttonStyle(.plain)
                            }
                        
                        Spacer()
                    }
                    
                }.padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(HomeSampleData.recent) { r in
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
                    .padding(.vertical, 4)
                }.padding()

            }
            
        }.padding(.all)
        
    }
    
}
        
    


#Preview {
    ProfileView()
}
