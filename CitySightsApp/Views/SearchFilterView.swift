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
    @Binding var limit: Int
    var body: some View {
        VStack{
            Text("Filter")
                .foregroundStyle(.primary)
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                .hSpacing()
            Toggle(isOn: $popular){
                Text("Popular")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            Toggle(isOn: $deals){
                Text("Deals")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            Text("Limit of Sights")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                
            Picker("", selection: $limit) {
                ForEach(1..<5) { i in
                    Text("\(i*10)")
                        .tag(i*10)
                }
            }
            .pickerStyle(.palette)
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    SearchFilterView(popular: .constant(false), deals: .constant(false), limit: .constant(10))
        .environment(BusinessViewModel())
}
