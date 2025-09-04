//
//  LocationProviding.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import Foundation
import CoreLocation

protocol LocationProviding {
    func requestLocation() async throws -> CLLocationCoordinate2D?
    var authorizationStatus: CLAuthorizationStatus { get }
}
