//
//  OnboardingPreviousButton.swift
//  Melanoma Detector
//
//  Created by Murad Talibov on 30.09.22.
//

import SwiftUI

struct OnboardingPreviousButton: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        if model.currentPage != .welcome {
        Button(action: model.previousPage) {
            Image(systemName: "chevron.left")
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
        }
        }
    }
}

struct OnboardingPreviousButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPreviousButton()
            .environmentObject(Model())
    }
}
