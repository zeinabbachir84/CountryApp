//
//  LocationError.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import Foundation
import CoreLocation

enum LocationError: LocalizedError {
    case permissionDenied
    case locationUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied."
        case .locationUnavailable:
            return "Unable to determine your location."
        case .unknown:
            return "An unexpected location error occurred."
        }
    }
}
