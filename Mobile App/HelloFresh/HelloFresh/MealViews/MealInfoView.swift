//
//  MealInfoView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealInfoView: View {
    @EnvironmentObject var model: Model
    var recipeID: String
    var isWideView: Bool = false
    
    var body: some View {
        if let imageURL = model.getRecipeByID(recipeID)?.imageURL,
           let url = URL(string: "https://" + imageURL) {
            CachedAsyncImage(url: url) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: isWideView ? 350 : 175, height: 175)
                        .overlay(alignment: .bottom) {
                                HStack {
                                    Spacer(minLength: 15)
                                    Text(model.getRecipeByID(recipeID)?.name ?? "")
                                        .foregroundColor(.white)
                                        .font(.custom("SourceSansPro-Bold", size: 14, relativeTo: .body))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    Spacer(minLength: 15)
                                }
                                .padding(.vertical, 10)
                                .background(
                                    Color.black.opacity(0.5)
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white.opacity(0.7))
                        .scaledToFill()
                        .frame(width: isWideView ? 350 : 175, height: 175)
                        .overlay {
                            ProgressView()
                        }
                }
            }
        } else {
            Image("food_placeholder")
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
        }
    }
}

#Preview {
    MealInfoView(recipeID: "")
        .environmentObject(Model())
}
