//
//  CountryDTO.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import Foundation

struct CountryDTO: Codable {
    let name: String
    let alpha2Code: String?
    let alpha3Code: String?
    let capital: String?
    let region: String?
    let latlng: [Double]?
    let currencies: [Currency]?

    var pngFlagURL: String? {
        guard let code = alpha2Code?.lowercased() else { return nil }
        return "https://flagcdn.com/w320/\(code).png"
    }
}
