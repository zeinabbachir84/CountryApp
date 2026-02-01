//
//  CountryAPI 2.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import Foundation

protocol CountryAPI {
    func fetchAllCountries() async throws -> [Country]
}
