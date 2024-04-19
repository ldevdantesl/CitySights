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
    case querySetError
    
    var message: String {
        switch self {
        case .badURL:
            return "URL is not valid for search."
        case .noAPIKey:
            return "Cant find API_KEY in the bundle."
        case .badURLResponse:
            return "Cant get URL Response from the server."
        case .querySetError:
            return "Can't create query set "
        }
    }
}

class DataManager{
    static let shared = DataManager()
    @Environment(BusinessViewModel.self) var businessVM
    
    func businessSearch(location: String, attributes: [String]?, searchText: String?, category: [String]?) async throws -> [Business]{
        
        let locationModified = location.replacingOccurrences(of: " ", with: "%20").capitalized
        var endpointURLString = "https://api.yelp.com/v3/businesses/search?location=\(locationModified)"
        
        if let searchText = searchText {
            guard let termModified = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Error: \(DataManagerErrors.querySetError)")
                throw DataManagerErrors.querySetError
            }
            endpointURLString.append("&term=\(termModified)")
        }
        
        if let category = category{
            endpointURLString.append("&category=")
            category.forEach { cat in
                if cat == category.last{
                    endpointURLString.append(cat)
                } else {
                    endpointURLString.append("\(cat),")
                }
            }
        }
        
        if let attributes = attributes{
            endpointURLString.append("&attributes=")
            attributes.forEach { attr in
                if attr == attributes.last{
                    endpointURLString.append(attr)
                } else {
                    endpointURLString.append("\(attr),")
                }
            }
        }
        
        endpointURLString.append("&limit=10")
        print(endpointURLString)
        
        guard let api_key = Bundle.main.infoDictionary?["API_KEY"] else {
            print("Error: \(DataManagerErrors.noAPIKey.message)")
            throw DataManagerErrors.noAPIKey
        }
        
        guard let endpointURL = URL(string: endpointURLString) else {
            print("Error: \(DataManagerErrors.badURL.message)")
            throw DataManagerErrors.badURL
        }
        
        let headers: [String:String] = [
            "accept" : "application/json",
            "Authorization" : "Bearer \(api_key)"
        ]

        var urlRequest = URLRequest(url: endpointURL)
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
