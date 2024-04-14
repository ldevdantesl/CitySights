//
//  CitySightsAppApp.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 8.04.2024.
//

import SwiftUI

@main
struct CitySightsAppApp: App {
    @AppStorage("onboarding") var onboarding = true
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(BusinessViewModel())
                .fullScreenCover(isPresented: $onboarding){
                    OnBoardingView()
                }
        }
    }
}
