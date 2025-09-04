//
//  LocalStore 2.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 03/09/2025.
//

import Foundation

protocol LocalStore {
    func saveSelectedCountries(_ ids: [String])
    func loadSelectedCountries() -> [String]
}
