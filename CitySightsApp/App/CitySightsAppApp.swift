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
    @State var businessVM = BusinessViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(BusinessViewModel())
                .fullScreenCover(isPresented: $onboarding){
                    OnBoardingView()
                        .environment(BusinessViewModel())
                }
                .onAppear{
                    if businessVM.locationAuthStatus == .notDetermined{
                        businessVM.getUserLocation()
                    }
                }
        }
    }
}
