//
//  HelloFreshApp.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

@main
struct HelloFreshApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Model())
        }
    }
}
