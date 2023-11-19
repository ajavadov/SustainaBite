//
//  MealView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealSmallView: View {
    @EnvironmentObject var model: Model
    var recipeID: String
    
    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.55)) {
                if let recipe = model.getRecipeByID(recipeID) {
                    model.recipesToHide.append(recipe)
                    model.addRecipeAsLiked(recipe)
                }
            }
        }) {
            MealInfoView(recipeID: recipeID)
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
        }
    }
}

#Preview {
    MealSmallView(recipeID: "southern-sausage-gravy-308032")
        .environmentObject(Model())
        .frame(width: 200, height: 200)
}
