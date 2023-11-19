//
//  TagsViewModel.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

@MainActor
class TagsViewModel: ObservableObject {
    @Published var tags: [Tag] = [
        .init("Vegan"),
        .init("Under 650 calories"),
        .init("Family-friendly"),
        .init("Gluten-free")
    ]
}
