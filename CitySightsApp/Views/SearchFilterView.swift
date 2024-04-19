//
//  SearchFilterView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 15.04.2024.
//

import SwiftUI

struct SearchFilterView: View {
    @Environment(BusinessViewModel.self) var businessVM
    @Binding var popular: Bool
    @Binding var deals: Bool
    var body: some View {
        VStack{
            Text("Filter")
                .foregroundStyle(.green)
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                .hSpacing()
            Toggle(isOn: $popular){
                Text("Popular")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.tint)
            }
            Toggle(isOn: $deals){
                Text("Deals")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.tint)
            }
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    SearchFilterView(popular: .constant(false), deals: .constant(false))
        .environment(BusinessViewModel())
}
