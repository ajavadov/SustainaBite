//
//  MealListView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealListView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your meals this week")
                .font(.custom("SourceSansPro-Bold", size: 34))
                .padding()
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(model.recipesChosen, id: \.self) { recipe in
                        MealView(recipeID: recipe.id)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    MealListView()
        .environmentObject(Model())
}
