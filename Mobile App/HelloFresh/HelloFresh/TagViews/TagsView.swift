//
//  TagsView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct TagsView: View {
    @EnvironmentObject var model: Model
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What types of recipes do you prefer?")
                .font(.custom("SourceSansPro-Regular", size: 28))
                .padding(.top, 10)
                .padding(.leading, 20)
            TagView(tagIndex: 0, isEcoFriendlyTag: true)
                .padding(.top)
                .padding(.horizontal)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(model.tags.indices.dropFirst(), id: \.self) { tagIndex in
                        TagView(tagIndex: tagIndex)
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private func tagView(tagName: String) -> some View {
        Button(action: { }) {
            HStack {
                Spacer(minLength: 0)
                Text(tagName)
                    .font(.custom("SourceSansPro-Bold", size: 15))
                    .foregroundColor(Color("FreshDarkGreen"))
                    .padding(14)
                Spacer(minLength: 0)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FreshDarkGreen"), lineWidth: 1)
            }
        }
    }
}

#Preview {
    TagsView()
        .environmentObject(Model())
}
