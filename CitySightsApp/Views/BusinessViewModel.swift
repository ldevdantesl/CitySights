//
//  BusinessViewModel.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 12.04.2024.
//

import Foundation
import SwiftUI

@Observable
class BusinessViewModel{
    var location: String = ""
    var businessQuery: [Business] = []
    var selectedBusiness: Business = Business(id: "", alias: "", name: "", categories: [], rating: 0.2, coordinates: .init(latitude: 0, longitude: 0), transactions: [], location: .init(address1: "", city: "", country: "", state: ""))
    
    var dataManager = DataManager.shared
    
    func makeTask() async throws{
        do {
            businessQuery = try await dataManager.businessSearch(with: location)
        } catch  {
            print(error.localizedDescription)
            throw error
        }
    
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
