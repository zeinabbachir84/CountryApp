//
//  CountriesViewModel.swift
//  CountryApp
//

import Foundation
import CoreLocation

@MainActor
final class CountriesViewModel: ObservableObject {
    // MARK: - Published state
    @Published var allCountries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var searchQuery: String = ""
    @Published var isWaitingForLocation: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Managers / Dependencies
    private let api: CountryAPI
    private let selectionManager: SelectionManager
    private let locationManager: LocationManager

    // MARK: - Initialization
    init(api: CountryAPI = CountryService(),
         selectionManager: SelectionManager = SelectionManager(),
         locationManager: LocationManager = LocationManager()) {
        self.api = api
        self.selectionManager = selectionManager
        self.locationManager = locationManager
    }

    // MARK: - Public API
    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await loadAllCountries()
            restoreSelectionFromManager()

            guard selectedCountries.isEmpty else { return }

            isWaitingForLocation = true
            defer { isWaitingForLocation = false }

            try await locationManager.handleLocationFlow(for: allCountries,
                                                        selection: selectionManager)
            // Sync the selection manager back to @Published
            restoreSelectionFromManager()
        } catch {
            errorMessage = mapError(error)
            if selectedCountries.isEmpty {
                if let lebanon = allCountries.first(where: { $0.name == "Lebanon" }) {
                    addCountry(lebanon)
                }
            }
        }
    }

    func addCountry(_ country: Country) {
        selectionManager.addCountry(country)
        selectedCountries = selectionManager.selectedCountries
    }

    func removeCountry(_ country: Country) {
        selectionManager.removeCountry(country)
        selectedCountries = selectionManager.selectedCountries
    }

    var filteredCountries: [Country] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allCountries }
        return allCountries.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    // MARK: - Private helpers
    private func loadAllCountries() async throws {
        let countries = try await api.fetchAllCountries()
        allCountries = countries.sorted { $0.name < $1.name }
    }

    private func restoreSelectionFromManager() {
        selectionManager.restoreSelection(from: allCountries)
        selectedCountries = selectionManager.selectedCountries
    }

    private func mapError(_ error: Error) -> String {
        if let countryError = error as? CountryError {
            return countryError.errorDescription ?? "An unexpected error occurred."
        }

        if let locationError = error as? LocationError {
            return locationError.errorDescription ?? "Unexpected location error."
        }

        return error.localizedDescription
    }
}
