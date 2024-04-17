//
//  SearchFilterView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 15.04.2024.
//

import SwiftUI

struct SearchFilterView: View {
    @Environment(BusinessViewModel.self) var businessVM
    @Binding var attributes: [String]
    @State private var popular: Bool = false
    @State private var deals: Bool = false
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
            .onChange(of: popular){ oldValue, newValue in
                if newValue == true{
                    attributes.append("hot_and_new")
                    print(attributes)
                } else {
                    attributes.removeAll { str in
                        str == "hot_and_new"
                    }
                    print(attributes)
                }
            }
            Toggle(isOn: $deals){
                Text("Deals")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.tint)
            }
            .onChange(of: deals){ oldValue, newValue in
                if newValue == true{
                    attributes.append("deals")
                    print(attributes)
                } else {
                    attributes.removeAll { str in
                        str == "deals"
                    }
                    print(attributes)
                }
            }
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    SearchFilterView(attributes: .constant([]))
        .environment(BusinessViewModel())
}
