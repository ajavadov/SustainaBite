//
//  SingleChoiceView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 19.11.23.
//

import SwiftUI

struct SingleChoiceView: View {
    @Binding var choices: [Tag]
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            ForEach(choices.indices, id: \.self) { choiceIndex in
                ChoiceView(choice: $choices[choiceIndex])
                    .padding(.horizontal)
                    .onChange(of: choices[choiceIndex].isSelected) { newValue in
                        updateSingleSelection(changedIndex: choiceIndex)
                    }
            }
            Spacer()
        }
    }
    
    private func updateSingleSelection(changedIndex: Int) {
        if choices[changedIndex].isSelected {
            for index in choices.indices {
                if index != changedIndex {
                    choices[index].isSelected = false
                }
            }
        }
    }
}

#Preview {
    SingleChoiceView(choices: .constant([
        .init("2"),
        .init("3"),
        .init("4")
    ]))
}
