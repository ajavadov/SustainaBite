//
//  Tag.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import Foundation

struct Tag: Codable, Hashable, SelectableItem {
    var isSelected: Bool = false
    var value: String
    
    init(isSelected: Bool, value: String) {
        self.isSelected = isSelected
        self.value = value
    }
    
    init(_ value: String) {
        self.value = value
    }
}
