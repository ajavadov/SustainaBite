//
//  NumberOfPersonsChoice.swift
//  HelloFresh
//
//  Created by Murad Talibov on 19.11.23.
//

import SwiftUI

struct FrequencyChoices: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
//            Spacer()
            Text("Number of people")
                .font(.custom("SourceSansPro-Regular", size: 30))
                .padding(.horizontal)
                .padding(.top)
//                .padding(.bottom, 10)
            SingleChoiceView(choices: $model.numberOfPersons)
                .padding(.bottom, 20)
//                .padding(.horizontal, 40)
            Text("Number of meals per week")
                .font(.custom("SourceSansPro-Regular", size: 30))
                .padding(.horizontal)
//                .padding(.bottom, 10)
            SingleChoiceView(choices: $model.mealsPerWeek)
            Spacer()
        }
    }
}

#Preview {
    FrequencyChoices()
        .environmentObject(Model())
}
