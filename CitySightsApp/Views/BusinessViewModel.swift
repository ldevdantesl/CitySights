//
//  BusinessViewModel.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 12.04.2024.
//

import Foundation
import SwiftUI
import CoreLocation

enum Categories{
    case restaurants
    case arts
    case beautysvc
    case fitness
}

@Observable
class BusinessViewModel: NSObject, CLLocationManagerDelegate{
    var businessQuery: [Business] = []
    var selectedBusiness: Business = Business(id: "", alias: "", name: "", categories: [], rating: 0.2, coordinates: .init(latitude: 0, longitude: 0), transactions: [], location: .init(address1: "", city: "", country: "", state: ""))
    
    var dataManager = DataManager.shared
    var locationManager = CLLocationManager() // Location Manager.
    var userCurrentLocation: CLLocationCoordinate2D?
    var categoriesSelected: [Categories] = [.restaurants]
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
    }
    
    func getResultsForSearchLocation(location: String,searchText: String, attributes: [String], categories: [String]) async throws{
        do {
            businessQuery = try await dataManager.businessSearch(location: location, userLocation: nil, attributes: attributes, searchText: searchText, category: categories)
        } catch  {
            print(error.localizedDescription)
            throw error
        }
    
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getResultsForUserLocation(searchText: String, attributes: [String], categories: [String]) async throws{
        do {
            businessQuery = try await dataManager.businessSearch(location: nil, userLocation: userCurrentLocation, attributes: attributes, searchText: searchText, category: categories)
        } catch  {
            print(error.localizedDescription)
            throw error
        }
    
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getUserLocation(){
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            userCurrentLocation = nil
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userCurrentLocation = locations.last?.coordinate
        print(userCurrentLocation as Any)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            userCurrentLocation = nil
            locationManager.requestLocation()
        }
    }
}
