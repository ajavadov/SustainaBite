//
//  MealView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealView: View {
    @EnvironmentObject var model: Model
    @State var isRecipePresented: Bool = false
    var recipeID: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                isRecipePresented = true
            }
        }) {
            MealInfoView(recipeID: recipeID, isWideView: true)
        }
        .overlay(alignment: .topLeading) {
            if let recipe = model.getRecipeByID(recipeID) {
                HStack(alignment: .center) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color("FreshGreen"))
                    Text(recipe.co2Rating)
                        .font(.custom("SourceSansPro-Regular", size: 18))
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                }
                .padding(.leading, 6)
                .padding(.top, 6)
            }
        }
        .fullScreenCover(isPresented: $isRecipePresented, content: {
            if let recipe = model.getRecipeByID(recipeID) {
                MealDetailView(meal: recipe)
            }
        })
    }
}

#Preview {
    MealView(recipeID: "")
        .environmentObject(Model())
}
