//
//  DataManger.swift
//  CitySightsApp
//
//  Created by Buzurg Rakhimzoda on 9.04.2024.
//

import Foundation
import SwiftUI
import CoreLocation

enum DataManagerErrors:Error, CaseIterable{
    case badURL
    case noAPIKey
    case badURLResponse
    
    var message: String {
        switch self {
        case .badURL:
            return "URL is not valid for search."
        case .noAPIKey:
            return "Cant find API_KEY in the bundle."
        case .badURLResponse:
            return "Cant get URL Response from the server."
        }
    }
}

class DataManager{
    static let shared = DataManager()
    
    func businessSearch(with location: String?, userLocation: CLLocationCoordinate2D?) async throws -> [Business]{
        var url = URL(string: "")
        if let location = location{
            let locationModified = location.replacingOccurrences(of: " ", with: "%20").capitalized
            url = URL(string:"https://api.yelp.com/v3/businesses/search?location=\(locationModified)&categories=restaurants&limit=10")
        }
        
        if let userLocation = userLocation{
            url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(userLocation.latitude)&longitude=\(userLocation.longitude)&categories=restaurants&limit=10")
        }
        
        guard let api_key = Bundle.main.infoDictionary?["API_KEY"] else {
            print("Error: \(DataManagerErrors.noAPIKey.message)")
            throw DataManagerErrors.noAPIKey
        }
        print(api_key)
        
        guard let url = url else {
            print("Error: \(DataManagerErrors.badURL.message)")
            throw DataManagerErrors.badURL
        }
        
        let headers: [String:String] = [
            "accept" : "application/json",
            "Authorization" : "Bearer \(api_key)"
        ]

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                print("Error:\(DataManagerErrors.badURL.message)")
                throw DataManagerErrors.badURL
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(BusinessQuery.self, from: data)
                return result.businesses
            } catch {
                print("Decoding error: \(error)")
                throw error
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
