//
//  OnboardingNextButton.swift
//  Melanoma Detector
//
//  Created by Murad Talibov on 30.09.22.
//

import SwiftUI

struct OnboardingNextButton: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        Button(action: model.nextPage) {
            if model.currentPage == .welcome {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(Color("FreshGreen"))
                        .frame(width: 130, height: 55)
                        .opacity(0.7)
                    Text("Get started")
                        .font(.custom("SourceSansPro-Bold" ,size: 16))
                        .foregroundColor(.white)
                }
            } else if model.currentPage == .meals {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(Color("FreshGreen"))
                        .frame(width: 130, height: 55)
                        .opacity(0.7)
                    Text("Start ordering")
                        .font(.custom("SourceSansPro-Bold" ,size: 16))
                        .foregroundColor(.white)
                }
            } else {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color("FreshGreen"))
                            .opacity(0.7)
                    )
                    .frame(width: 55, height: 55)
            }
        }
    }
}

struct OnboardingNextButton_Previews: PreviewProvider {
    static var viewModel = Model()
    
    static var previews: some View {
        viewModel.currentPage = .welcome
        return OnboardingNextButton()
            .environmentObject(viewModel)
    }
}
