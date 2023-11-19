//
//  MealsView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealLearningView: View {
    @EnvironmentObject var model: Model
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 0) {
                HStack {
                    Text("Choose meals that you like")
                        .font(.custom("SourceSansPro-Regular", size: 30))
                        .padding(.top, 10)
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("Our clever algorithm will learn your tastes and offer you the best recipes")
                        .font(.custom("SourceSansPro-Regular", size: 15))
                        .padding(.top, 10)
                        .padding(.leading, 20)
                    Spacer()
                }
            }
            Text("")
            Spacer()
            if !model.recipesLoading {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(model.recipes, id: \.self) { recipe in
                            if !model.recipesToHide.contains(where: { $0.id == recipe.id }) {
                                MealSmallView(recipeID: recipe.id)
                            }
                        }
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
            Spacer()
        }
    }
}

#Preview {
    MealLearningView()
        .environmentObject(Model())
}
