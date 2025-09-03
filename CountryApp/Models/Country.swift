//
//  Country.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


// =============================================================
// MARK: - File: Models/Country.swift
// =============================================================

import Foundation

struct Country: Codable, Identifiable, Hashable {
    var id: String { alpha2Code ?? name }
    let name: String
    let alpha2Code: String? // 2-letter ISO country code
    let alpha3Code: String? // 3-letter ISO country code
    let capital: String?
    let region: String?
    let latlng: [Double]? // an array of latitude and longitude coordinates
    let currencies: [Currency]?
    
    var pngFlagURL: URL? {
        guard let code = alpha2Code?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !code.isEmpty else { return nil }
        return URL(string: "https://flagcdn.com/w320/\(code).png")
    }
}
