//
//  MealSuggestionsView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealSuggestionsView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose your weekly meals")
                .font(.custom("SourceSansPro-Bold", size: 34))
                .padding()
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(model.recipes, id: \.self) { recipe in
                        MealSelectView(recipeID: recipe.id)
                    }
                }
                .padding()
            }
            Button(action: {
                model.confirmMeals()
            }, label: {
                HStack {
                    Spacer()
                    Text("Order meals")
                        .foregroundColor(.white)
                        .font(.custom("SourceSansPro-Regular", size: 20))
                    Spacer()
                }
                .padding(.vertical, 10)
                .background {
                    Color("FreshGreen")
                        .cornerRadius(10)
                }
                .padding(.horizontal, 25)
            })
            .disabled(model.recipesChosen.count != model.numberOfMealsToChoose)
        }
    }
}

#Preview {
    MealSuggestionsView()
        .environmentObject(Model())
}
