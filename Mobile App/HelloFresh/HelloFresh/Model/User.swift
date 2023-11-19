//
//  User.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var username: String
    var selectedRecipes: [Recipe] = []
    var selectedTags: [Tag] = []
    var isOnboarded: Bool = false
    var liked: [String] = []
}
