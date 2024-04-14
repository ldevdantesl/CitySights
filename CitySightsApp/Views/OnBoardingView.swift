//
//  OnBoardingView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 13.04.2024.
//

import SwiftUI

enum OnBoardingPages: Int, CaseIterable{
    case firstPage = 1
    case secondPage
}

struct OnBoardingView: View {
    @State private var selectedTab: OnBoardingPages = .firstPage
    @AppStorage("onboarding") var onboarding = true
    var body: some View {
        ZStack{
            selectedTab == .firstPage ?
            Color.purple.opacity(0.8).ignoresSafeArea() :  
            Color.green.ignoresSafeArea()
            
            VStack{
                Spacer()
                TabView(selection:$selectedTab){
                    VStack{
                        Spacer()
                        Image("onboarding")
                            .resizable().scaledToFit()
                            .frame(width: 340, height: 320)
                        Text("Welcome to City Sights!")
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("City Sights helps you find the best of the city!")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(10)
                    .tag(OnBoardingPages.firstPage)
                    VStack{
                        Spacer()
                        Image("onboarding")
                            .resizable().scaledToFit()
                            .frame(width: 340, height: 320)
                        Text("Discover your City!")
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("We will show you the best restaurants, venues, and more, based on your location.")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .tag(OnBoardingPages.secondPage)
                    .padding(10)
                }
                .frame(width: 400, height: screen.height / 2 + screen.height / 4)
                .tabViewStyle(PageTabViewStyle())
                Spacer()
                Button{
                    if selectedTab == .firstPage{
                        withAnimation {
                            selectedTab = .secondPage
                        }
                    } else {
                        onboarding.toggle()
                    }
                } label:{
                    Text("Continue")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: screen.width - 20, height: 50)
                        .background(Color.white, in:.rect(cornerRadius: 15))
                }
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
