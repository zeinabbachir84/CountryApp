//
//  LocationManager.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//


import CoreLocation

final class LocationManager {
    private let locationService: LocationProviding
    private let defaultCountryName: String

    init(locationService: LocationProviding = LocationService(),
         defaultCountryName: String = "Lebanon") {
        self.locationService = locationService
        self.defaultCountryName = defaultCountryName
    }

    func handleLocationFlow(for countries: [Country], selection: SelectionManager) async throws {
        switch locationService.authorizationStatus {
        case .notDetermined:
            if let coord = try await locationService.requestLocation() {
                addNearestCountry(to: coord, countries: countries, selection: selection)
            } else {
                addDefaultCountry(countries: countries, selection: selection)
            }

        case .denied, .restricted:
            addDefaultCountry(countries: countries, selection: selection)

        case .authorizedAlways, .authorizedWhenInUse:
            if let coord = try await locationService.requestLocation() {
                addNearestCountry(to: coord, countries: countries, selection: selection)
            } else {
                addDefaultCountry(countries: countries, selection: selection)
            }

        @unknown default:
            addDefaultCountry(countries: countries, selection: selection)
        }
    }

    private func addDefaultCountry(countries: [Country], selection: SelectionManager) {
        guard let defaultCountry = countries.first(where: { $0.name == defaultCountryName }) else { return }
        selection.addCountry(defaultCountry)
    }

    private func addNearestCountry(to location: CLLocationCoordinate2D,
                                   countries: [Country],
                                   selection: SelectionManager) {
        guard !countries.isEmpty else { return }

        let nearest = countries.min { distance(from: location, to: $0) < distance(from: location, to: $1) }

        if let nearest = nearest {
            selection.addCountry(nearest)
        }
    }

    private func distance(from location: CLLocationCoordinate2D, to country: Country) -> CLLocationDistance {
        guard let coords = country.latlng, coords.count == 2 else { return .greatestFiniteMagnitude }
        let countryLoc = CLLocation(latitude: coords[0], longitude: coords[1])
        let userLoc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return countryLoc.distance(from: userLoc)
    }
}
