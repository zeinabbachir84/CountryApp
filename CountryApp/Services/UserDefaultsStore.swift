//
//  LocalStore.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import Foundation

final class UserDefaultsStore: LocalStore {
    private let key = "selected_countries_ids"
    
    func saveSelectedCountries(_ ids: [String]) {
        UserDefaults.standard.set(ids, forKey: key)
    }
    
    func loadSelectedCountries() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
