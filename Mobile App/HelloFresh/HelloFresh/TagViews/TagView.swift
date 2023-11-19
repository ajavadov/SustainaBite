//
//  TagView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct TagView: View {
    @EnvironmentObject var model: Model
    let tagIndex: Int
    var isEcoFriendlyTag: Bool = false
    
    var body: some View {
        Button(action: { model.tags[tagIndex].isSelected.toggle() }) {
            HStack {
                Spacer(minLength: 0)
                if isEcoFriendlyTag {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color("FreshGreen"))
                }
                Text(model.tags[tagIndex].value)
                    .font(.custom("SourceSansPro-Bold", size: 15))
                    .foregroundColor(Color("FreshDarkGreen"))
                    .padding(14)
                Spacer(minLength: 0)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FreshDarkGreen"), lineWidth: 1)
                    .background { model.tags[tagIndex].isSelected ? Color("FreshGreen").opacity(0.2) : Color.clear }
            }
            .overlay(alignment: .topLeading) {
                if model.tags[tagIndex].isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .background {
                            Circle()
                                .fill(Color("FreshGreen"))
                                .frame(width: 20, height: 20)
                            
                        }
                }
            }
        }
    }
}

#Preview {
    TagView(tagIndex: 0)
        .environmentObject(Model())
}
