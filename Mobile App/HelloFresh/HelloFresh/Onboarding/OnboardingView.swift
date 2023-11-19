//
//  OnboardingView.swift
//  Melanoma Detector
//
//  Created by Murad Talibov on 30.09.22.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .trailing) {
            TabView(selection: $model.currentPage) {
                WelcomeView()
                    .tag(OnboardingPage.welcome)
                TagsView()
                    .tag(OnboardingPage.tags)
                FrequencyChoices()
                    .tag(OnboardingPage.frequencies)
                MealLearningView()
                    .tag(OnboardingPage.meals)
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.bottom, 20)
            HStack {
                OnboardingPreviousButton()
                    .padding(.leading, 40)
                Spacer()
                OnboardingNextButton()
                    .padding(.trailing, 20)
            }
        }
        .background(Color("OnboardingGreen"))
        .animation(.linear(duration: 0.2))
        .transition(.slide)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var model = Model()
    
    static var previews: some View {
        model.currentPage = .welcome
        return OnboardingView()
            .environmentObject(model)
    }
}
