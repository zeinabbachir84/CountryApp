//
//  CountryError.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import Foundation

enum CountryError: LocalizedError {
    case network
    case decoding
    case locationDenied
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .network: return "Failed to fetch countries. Please try again."
        case .decoding: return "Data could not be decoded."
        case .locationDenied: return "Location permission denied."
        case .unknown: return "An unexpected error occurred."
        }
    }
}
