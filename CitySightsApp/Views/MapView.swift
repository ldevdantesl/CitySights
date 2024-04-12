//
//  MapView.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 12.04.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(BusinessViewModel.self) var businessVM
    @State var selectedBusinessId: String? = ""
    @State var showDetailView: Bool = false
    var body: some View {
        Map(selection: $selectedBusinessId){
            ForEach(businessVM.businessQuery, id: \.id){ business in
                Marker(business.name, coordinate: CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude))
                    .tag(business.id)
            }
        }
        .fullScreenCover(isPresented:$showDetailView){
            BusinessDetailView(goBack: $showDetailView)
        }
        .onChange(of: selectedBusinessId) { oldValue, newValue in
            let business = businessVM.businessQuery.first { bsn in
                bsn.id == selectedBusinessId
            }
            if let business = business{
                businessVM.selectedBusiness = business
                showDetailView.toggle()
            }
        }
    }
}

#Preview {
    MapView()
        .environment(BusinessViewModel())
}
