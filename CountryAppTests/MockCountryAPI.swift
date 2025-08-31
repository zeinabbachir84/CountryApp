//
//  MockCountryAPI.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


import Foundation
@testable import CountryApp

final class MockCountryAPI: CountryAPI {
    var countriesToReturn: [Country] = []

    func fetchAllCountries() async throws -> [Country] {
        return countriesToReturn
    }
}
