//
//  ChoiceView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 19.11.23.
//

import SwiftUI

struct ChoiceView: View {
    @Binding var choice: Tag
    
    var body: some View {
        Button(action: { choice.isSelected.toggle() }) {
            HStack {
                Spacer(minLength: 0)
                Text(choice.value)
                    .font(.custom("SourceSansPro-Bold", size: 15))
                    .foregroundColor(choice.isSelected ? Color.white : Color("FreshDarkGreen"))
                    .padding(14)
                Spacer(minLength: 0)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FreshGreen"), lineWidth: 1)
                    .overlay {
                        Group {
                            choice.isSelected ? Color("FreshGreen").opacity(1) : Color.clear
                        }
                        .cornerRadius(10)
                        .padding(0.1)
                    }
            }
            .padding()
        }
    }
}

#Preview {
    ChoiceView(choice: .constant(.init("3")))
}
