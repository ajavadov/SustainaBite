//
//  MealSelectView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealSelectView: View {
    @EnvironmentObject var model: Model
    var recipeID: String
    
    var body: some View {
        Button(action: {
            if model.isRecipeChosen(model.getRecipeByID(recipeID)) {
                model.recipesChosen.removeAll(where: { $0.id == self.recipeID })
            } else {
                if let recipe = model.getRecipeByID(recipeID) {
                    model.recipesChosen.append(recipe)
                }
            }
        }) {
            MealInfoView(recipeID: recipeID, isWideView: true)
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
                .overlay {
                    if model.isRecipeChosen(model.getRecipeByID(recipeID)) {
                        Color.black.opacity(0.5)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if model.isRecipeChosen(model.getRecipeByID(recipeID)) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .background {
                                Circle()
                                    .fill(Color("FreshGreen"))
                                    .frame(width: 30, height: 30)
                                
                            }
                    }
                }
        }
    }
}

#Preview {
    MealSelectView(recipeID: "")
        .environmentObject(Model())
}
