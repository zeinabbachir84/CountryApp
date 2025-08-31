//
//  CountriesViewModelTests.swift
//  CountryAppTests
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import XCTest
@testable import CountryApp

@MainActor
final class CountriesViewModelTests: XCTestCase {
    
    var mockAPI: MockCountryAPI!
    var mockStore: MockLocalStore!
    var viewModel: CountriesViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockCountryAPI()
        mockStore = MockLocalStore()
        viewModel = CountriesViewModel(api: mockAPI, store: mockStore)
    }
    
    override func tearDown() {
        mockAPI = nil
        mockStore = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadInitialDataFetchesCountries() async throws {
        // Given
        let france = Country(
            name: "France",
            alpha2Code: "FR",
            alpha3Code: "FRA",
            capital: "Paris",
            region: "Europe",
            latlng: [46.0, 2.0],
            flag: "https://flagcdn.com/fr.svg",
            currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")]
        )
        mockAPI.countriesToReturn = [france]
        
        // When
        await viewModel.loadInitialData()
        
        // Then
        XCTAssertEqual(viewModel.allCountries.count, 1)
        XCTAssertEqual(viewModel.allCountries.first?.name, "France")
    }
    
    func testSelectCountryAddsToSelected() async throws {
        // Given
        let france = makeDummyCountry(name: "France")
        
        // When
        viewModel.addCountry(france)
        
        // Then
        XCTAssertTrue(viewModel.selectedCountries.contains(where: { $0.name == "France" }))
        XCTAssertEqual(mockStore.savedIds.count, 1)
    }
    
    func testRemoveCountryFromSelected() async throws {
        // Given
        let france = makeDummyCountry(name: "France")
        viewModel.addCountry(france)
        
        // When
        viewModel.removeCountry(france)
        
        // Then
        XCTAssertFalse(viewModel.selectedCountries.contains(where: { $0.name == "France" }))
        XCTAssertEqual(mockStore.savedCountries.count, 0)
    }
    
    func testSelectCountryLimitFive() async throws {
        // Given 5 countries already selected
        for i in 1...5 {
            viewModel.addCountry(makeDummyCountry(name: "Country\(i)"))
        }
        XCTAssertEqual(viewModel.selectedCountries.count, 5)
        
        // When attempting to add a 6th
        viewModel.addCountry(makeDummyCountry(name: "ExtraCountry"))
        
        // Then it should still be 5, not 6
        XCTAssertEqual(viewModel.selectedCountries.count, 5)
        XCTAssertFalse(viewModel.selectedCountries.contains(where: { $0.name == "ExtraCountry" }))
    }
    
    // MARK: - Helpers
    private func makeDummyCountry(name: String) -> Country {
        Country(
            name: name,
            alpha2Code: String(name.prefix(2)).uppercased(),
            alpha3Code: String(name.prefix(3)).uppercased(),
            capital: nil,
            region: "TestRegion",
            latlng: [],
            flag: nil,
            currencies: []
        )
    }
}
