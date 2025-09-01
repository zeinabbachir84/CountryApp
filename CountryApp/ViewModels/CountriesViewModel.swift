//
//  CountriesViewModel.swift
//  CountryApp
//

import Foundation
import CoreLocation

protocol LocationProviding {
    func requestLocation() async throws -> CLLocationCoordinate2D?
    var authorizationStatus: CLAuthorizationStatus { get }
}

@MainActor
final class CountriesViewModel: ObservableObject {
    // MARK: - Published state
    @Published var allCountries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var searchQuery: String = ""
    @Published var isWaitingForLocation: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    private let api: CountryAPI
    private let store: LocalStore
    private let locationService: LocationProviding

    // MARK: - Initialization
    init(api: CountryAPI = CountryService(),
         store: LocalStore = UserDefaultsStore(),
         locationService: LocationProviding = LocationService()) {
        self.api = api
        self.store = store
        self.locationService = locationService
    }

    // MARK: - Loading initial data
    func loadInitialData() async {
        isLoading = true
        do {
            // Load all countries
            let countries = try await api.fetchAllCountries()
            allCountries = countries.sorted { $0.name < $1.name }

            // Restore previous selection
            restoreSelection(from: countries)

            // If the user already has selected countries, skip location
            guard selectedCountries.isEmpty else {
                isLoading = false
                return
            }

            // First launch: wait for location
            isWaitingForLocation = true
            defer { isWaitingForLocation = false }

            if locationService.authorizationStatus == .notDetermined {
                // Ask for permission, wait for user choice
                if let coordinate = try await locationService.requestLocation() {
                    addNearestCountry(to: coordinate)
                } else {
                    addDefaultCountry()
                }
            } else if locationService.authorizationStatus == .denied
                        || locationService.authorizationStatus == .restricted {
                // User denied/restricted: fallback to default
                addDefaultCountry()
            } else {
                // Already authorized: get current location
                if let coordinate = try await locationService.requestLocation() {
                    addNearestCountry(to: coordinate)
                } else {
                    addDefaultCountry()
                }
            }

        } catch {
            errorMessage = error.localizedDescription
            // fallback to default country if error
            if selectedCountries.isEmpty { addDefaultCountry() }
        }
        isLoading = false
    }

    // MARK: - Selection
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else { return }
        guard !selectedCountries.contains(where: { $0.id == country.id }) else { return }

        selectedCountries.append(country)
        persistSelection()
    }

    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0.id == country.id }
        persistSelection()
    }

    private func persistSelection() {
        store.saveSelectedCountries(selectedCountries.map { $0.id })
    }

    private func restoreSelection(from countries: [Country]) {
        let ids = store.loadSelectedCountries()
        selectedCountries = countries.filter { ids.contains($0.id) }
    }

    // MARK: - Location helpers
    private func addDefaultCountry() {
        if let lebanon = allCountries.first(where: { $0.name == "Lebanon" }) {
            addCountry(lebanon)
        }
    }

    private func addNearestCountry(to location: CLLocationCoordinate2D) {
        guard !allCountries.isEmpty else { return }

        let nearest = allCountries.min { a, b in
            guard let aCoords = a.latlng, let bCoords = b.latlng else { return false }
            let aDistance = CLLocation(latitude: aCoords[0], longitude: aCoords[1])
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            let bDistance = CLLocation(latitude: bCoords[0], longitude: bCoords[1])
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            return aDistance < bDistance
        }

        if let nearest = nearest {
            addCountry(nearest)
        }
    }

    // MARK: - Search
    var filteredCountries: [Country] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allCountries }
        return allCountries.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}
