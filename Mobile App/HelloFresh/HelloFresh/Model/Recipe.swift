//
//  Recipe.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import Foundation

struct Recipe: Codable, Hashable, Identifiable, Equatable {
    var id: String
    var name: String
    var ingredients: [String]?
    var headline: String?
    var prepTime: String?
    var image: String?
    var imageURL: String?
    var tags: [Tag]?
    var nutrition: Nutrition?
    var course: [String]
    var cuisine: [String]
    var rating: String
    var co2Rating: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "recipeName"
        case ingredients = "ingredients"
        case headline
        case prepTime = "timeMins"
        case image
        case imageURL = "image_url"
        case tags
        case nutrition
        case course
        case cuisine
        case rating
        case co2Rating = "co2rating"
    }
}


struct Nutrition: Codable, Hashable, Equatable {
    let energy: Int
    let calories: Int
    let carbohydrate: Double
    let protein: Double
}
