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
    var selectedBusiness: Business = Business(id: "", alias: "", name: "", categories: [], rating: 0.2, coordinates: .init(latitude: 0, longitude: 0), transactions: [], location: .init(address1: "", city: "", country: "", state: "", displayAddress: []))
    
    var dataManager = DataManager.shared
    var locationManager = CLLocationManager() // Location Manager.
    var userLocation: CLLocationCoordinate2D?
    var userLocationArea: String?
    var categoriesSelected: [Categories] = [.restaurants]
    
    var locationAuthStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    func getUserLocation(){
        locationManager.requestLocation()
    }
    
    func getResults(searchText: String, attributes: [String], categories: [String], location: String) async throws {
        do {
            let businessQuery = try await dataManager.businessSearch(
                location: location,
                attributes: attributes,
                searchText: searchText,
                category: categories
            )
            await MainActor.run{
                self.businessQuery = businessQuery
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }

        // Dismiss the keyboard if necessary
        await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown city"
                let state = placemark.administrativeArea ?? "Unknown state"
                DispatchQueue.main.async {
                    // Combine city and state in one string
                    self?.userLocationArea = "\(city), \(state)"
                }
            } else if let error = error {
                print("Reverse geocoding failed: \(error)")
                DispatchQueue.main.async {
                    self?.userLocationArea = "Unable to determine location"
                }
            }
        }
    }
    
    private func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus

        DispatchQueue.main.async {
            self.locationAuthStatus = status // Update authorization status asynchronously on the main thread
        }

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start location updates only if authorized
        case .restricted, .denied:
            print("Location access denied or restricted")
        @unknown default:
            print("Unhandled authorization status: \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
            reverseGeocodeLocation(location)
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
