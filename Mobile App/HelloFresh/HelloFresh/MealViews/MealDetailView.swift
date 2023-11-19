//
//  MealDetailView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct MealDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let meal: Recipe
    let isPreview: Bool
    
    init(meal: Recipe, isPreview: Bool = false) {
        self.meal = meal
        self.isPreview = isPreview
    }
    
    var body: some View {
        VStack {
            ImageView(imageURL: .init(string: meal.imageURL != nil ? "https://" + meal.imageURL! : ""))
                .padding(.top, 40)
                .overlay(alignment: .topLeading) {
                    HStack(alignment: .center) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("FreshGreen"))
                        Text(meal.co2Rating)
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
                    .padding(.top, 45)
                }
            info
                .padding()
            preparationTime
            Divider()
            Spacer()
            ingredients
                .padding()
//            Spacer()
//            if !isPreview {
//                startButton
//            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.trailing)
            }
        }
        .background {
            VStack(spacing: 10) {
                Color("FreshGreen").opacity(0.7)
                    .frame(height: 250)
                    .padding(.bottom, 100)
                    .padding(.top, -60)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var info: some View {
        VStack(spacing: 10) {
            Text(meal.name)
                .font(.custom("SourceSansPro-Bold", size: 32))
                .font(.title.bold())
            Text(meal.headline ?? "")
                .font(.custom("SourceSansPro-Bold", size: 16))
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    var preparationTime: some View {
        HStack {
            if let prepTimeText = meal.prepTime,
               let prepTimeValue = Double(prepTimeText) {
                Image(systemName: "clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14)
                    .foregroundColor(.gray)
                Text("\(Int(prepTimeValue.rounded())) minutes")
                    .font(.custom("SourceSansPro-Regular", size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    var ingredients: some View {
        if let ingredients = meal.ingredients {
            VStack(spacing: 35) {
                Text("Ingredients")
                    .font(.custom("SourceSansPro-Bold", size: 24))
                    .foregroundColor(Color("FreshGreen"))
                ScrollView {
                    LazyVGrid(columns: [.init(.fixed(120)), .init(.fixed(120))], spacing: 10) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            VStack {
                                Text(ingredient.trimmingCharacters(in: .punctuationCharacters))
                                    .multilineTextAlignment(.center)
                                    .font(.custom("SourceSansPro-Regular", size: 18))
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var startButton: some View {
        Button(action: { }, label: {
            HStack {
                Spacer()
                Text("Start preparing")
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
    }
}

#Preview {
    MealDetailView(meal: Model().recipes.first!)
}
