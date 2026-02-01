//
//  MockLocationService.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import CoreLocation
@testable import CountryApp

final class MockLocationService: LocationProviding {
    var coordinateToReturn: CLLocationCoordinate2D? = nil
    var shouldThrowError = false
    var authorizationStatusToReturn: CLAuthorizationStatus = .authorizedWhenInUse

    var authorizationStatus: CLAuthorizationStatus { authorizationStatusToReturn }

    func requestLocation() async throws -> CLLocationCoordinate2D? {
        if shouldThrowError { throw URLError(.notConnectedToInternet) }
        return coordinateToReturn
    }
}
