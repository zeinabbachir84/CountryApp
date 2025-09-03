//
//  MockLocalStore.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

@testable import CountryApp

final class MockLocalStore: LocalStore {
    var savedIds: [String] = []

    func saveSelectedCountries(_ ids: [String]) {
        savedIds = ids
    }

    func loadSelectedCountries() -> [String] {
        savedIds
    }
}
