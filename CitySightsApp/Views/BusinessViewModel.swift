//
//  BusinessViewModel.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 12.04.2024.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable
class BusinessViewModel: NSObject, CLLocationManagerDelegate{
    var location: String = ""
    var businessQuery: [Business] = []
    var selectedBusiness: Business = Business(id: "", alias: "", name: "", categories: [], rating: 0.2, coordinates: .init(latitude: 0, longitude: 0), transactions: [], location: .init(address1: "", city: "", country: "", state: ""))
    
    var dataManager = DataManager.shared
    var locationManager = CLLocationManager() // Location Manager.
    var userCurrentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
    }
    
    func getResultsForSearchLocation() async throws{
        do {
            businessQuery = try await dataManager.businessSearch(with: location, userLocation: nil)
        } catch  {
            print(error.localizedDescription)
            throw error
        }
    
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getResultsForUserLocation() async throws{
        do {
            print(userCurrentLocation as Any)
            businessQuery = try await dataManager.businessSearch(with: nil, userLocation: userCurrentLocation)
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
