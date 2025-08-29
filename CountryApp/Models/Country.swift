//
//  Currency.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


// =============================================================
// MARK: - File: Models/Country.swift
// =============================================================
import Foundation

struct Currency: Codable, Hashable, Identifiable {
    var id: String { code ?? name ?? UUID().uuidString }
    let code: String?
    let name: String?
    let symbol: String?
}

struct Country: Codable, Identifiable, Hashable {
    var id: String { alpha2Code ?? name }
    let name: String
    let alpha2Code: String?
    let alpha3Code: String?
    let capital: String?
    let region: String?
    let latlng: [Double]?
    let flag: String? // URL string
    let currencies: [Currency]?
}
