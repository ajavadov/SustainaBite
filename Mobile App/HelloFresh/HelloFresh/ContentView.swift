//
//  ContentView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        if !model.isOnboardingFinished {
            OnboardingView()
        } else if !model.isWeeklyMenuPrepared {
            MealSuggestionsView()
        } else {
            MealListView()
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Model())
}
