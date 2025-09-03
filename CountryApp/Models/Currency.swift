//
//  Currency.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.


// =============================================================
// MARK: - File: Models/Currency.swift
// =============================================================

import Foundation

struct Currency: Codable, Hashable, Identifiable {
    var id: String { code ?? name ?? UUID().uuidString }
    let code: String?
    let name: String?
    let symbol: String?
}
