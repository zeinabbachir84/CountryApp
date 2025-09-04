//
//  SelectionManager.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//


import Foundation

final class SelectionManager {
    private let store: LocalStore
    private let maxSelection: Int
    private(set) var selectedCountries: [Country] = []

    init(store: LocalStore = UserDefaultsStore(), maxSelection: Int = 5) {
        self.store = store
        self.maxSelection = maxSelection
    }

    func addCountry(_ country: Country) {
        guard selectedCountries.count < maxSelection,
              !selectedCountries.contains(where: { $0.id == country.id }) else { return }
        selectedCountries.append(country)
        persistSelection()
    }

    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0.id == country.id }
        persistSelection()
    }

    func restoreSelection(from countries: [Country]) {
        let savedIds = store.loadSelectedCountries()
        selectedCountries = countries.filter { savedIds.contains($0.id) }
    }

    private func persistSelection() {
        store.saveSelectedCountries(selectedCountries.map { $0.id })
    }
}
