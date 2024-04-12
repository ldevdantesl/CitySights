// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct BusinessQuery: Codable, Hashable {
    var businesses: [Business]
    var total: Int
    var region: Region
}

// MARK: - Business
struct Business: Codable, Hashable{
    var id: String
    var alias, name: String
    var imageURL: String?
    var isClosed: Bool?
    var url: String?
    var reviewCount: Int?
    var categories: [Category]
    var rating: Double
    var coordinates: Center
    var transactions: [String]
    var price: String?
    var location: Location
    var phone, displayPhone: String?
    var distance: Double?
    var attributes: Attributes?
    
    enum CodingKeys: String, CodingKey{
        case id, alias, name, url, categories, rating, coordinates, transactions, price, location, phone, distance, attributes
        case reviewCount = "review_count"
        case imageURL = "image_url"
        case displayPhone = "display_phone"
        case isClosed = "is_closed"
    }
}

// MARK: - Attributes
struct Attributes: Codable, Hashable{
    var businessTempClosed: Bool?
    var menuURL: String?
    var open24Hours: Bool?
    var waitlistReservation: Bool?
}

// MARK: - Category
struct Category: Codable, Hashable{
    var alias, title: String?
}

// MARK: - Center
struct Center: Codable, Hashable{
    var latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable, Hashable{
    var address1: String
    var address2, address3: String?
    var city: String
    var zipCode: String?
    var country: String
    var state: String
    var displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey{
        case address1,address2, address3, city, zipCode, country, state
        case displayAddress = "display_address"
    }
}

// MARK: - Region
struct Region: Codable, Hashable{
    var center: Center?
}
