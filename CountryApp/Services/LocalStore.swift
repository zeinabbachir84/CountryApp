//
//  LocalStore.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


import Foundation

// Keeping the LocalStore protocol and its implementation in the same file
// is fine for this small project. This keeps related types together
// and improves readability without over-complicating the file structure.

protocol LocalStore {
    func saveSelectedCountries(_ ids: [String])
    func loadSelectedCountries() -> [String]
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
