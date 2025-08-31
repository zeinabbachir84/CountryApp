//
//  MockLocalStore.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//

@testable import CountryApp

final class MockLocalStore: LocalStore {
    var savedIds: [String] = []
    var savedCountries: [Country] = []
    
    func saveSelectedCountries(_ ids: [String]) {
        savedIds = ids
    }

    func loadSelectedCountries() -> [String] {
        return savedIds
    }
}
