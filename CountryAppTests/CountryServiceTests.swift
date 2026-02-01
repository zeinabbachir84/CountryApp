//
//  CountryServiceTests.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


import XCTest
@testable import CountryApp

final class CountryServiceTests: XCTestCase {

    func testFetchAllCountriesDecoding() async throws {
        // Sample JSON to validate decoding works
        let json = """
        [
          {
            "name": "France",
            "alpha2Code": "FR",
            "alpha3Code": "FRA",
            "capital": "Paris",
            "region": "Europe",
            "latlng": [46.0, 2.0],
            "flag": "https://flagcdn.com/fr.svg",
            "currencies": [{"code":"EUR","name":"Euro","symbol":"€"}]
          }
        ]
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let countries = try decoder.decode([Country].self, from: json)
        
        XCTAssertEqual(countries.first?.name, "France")
        XCTAssertEqual(countries.first?.capital, "Paris")
        XCTAssertEqual(countries.first?.currencies?.first?.code, "EUR")
    }
}
