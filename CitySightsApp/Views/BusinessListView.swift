//
//  BusinessListView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 11.04.2024.
//

import SwiftUI
import MapKit

enum BusinessViewSelection: Hashable, CaseIterable{
    case mapView
    case listView
    
    var title: String {
        switch self {
        case .mapView:
            return "Map View"
        case .listView:
            return "List View"
        }
    }
}

struct BusinessListView: View {
    @Environment(BusinessViewModel.self) var businessVM
    @Binding var location: String
    @State var selection: BusinessViewSelection = .listView
    @State var showBusinessView: Bool = false
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                HStack{
                    Image(systemName:"mappin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(location)
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                }
                Picker("", selection: $selection) {
                    ForEach(BusinessViewSelection.allCases, id: \.self){ sel in
                        Text(sel.title)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                if selection == .listView{
                    ScrollView{
                        Text("Sights")
                            .font(.system(.title, design: .rounded, weight: .semibold))
                            .hSpacing()
                        
                        ForEach(businessVM.businessQuery, id: \.id) {business in
                            BusinessRowView(business: business)
                        }
                    }
                    .scrollIndicators(.hidden)
                } else {
                    MapView()
                }
               
            }
            .padding(10)
            .padding(.horizontal,10)
        }
    }
}

#Preview {
    BusinessListView(location: .constant("Location"))
        .environment(BusinessViewModel())
}
