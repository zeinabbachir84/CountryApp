//
//  LocalStore.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import Foundation

protocol LocalStore {
    func saveSelectedCountries(_ ids: [String])
    func loadSelectedCountries() -> [String]
    func loadSavedCountries(from countries: [Country]) -> [Country]
}

final class UserDefaultsStore: LocalStore {
    private let key = "selected_countries_ids"
    
    func saveSelectedCountries(_ ids: [String]) {
        UserDefaults.standard.set(ids, forKey: key)
    }
    
    func loadSelectedCountries() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}

extension LocalStore {
    func loadSavedCountries(from countries: [Country]) -> [Country] {
        let savedIds = loadSelectedCountries()
        return countries.filter { savedIds.contains($0.id) }
    }
}
