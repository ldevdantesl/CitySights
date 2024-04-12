//
//  CitySightsAppApp.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 8.04.2024.
//

import SwiftUI

@main
struct CitySightsAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(BusinessViewModel())
        }
    }
}
