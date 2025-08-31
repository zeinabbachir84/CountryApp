//
//  CountryAppApp.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import SwiftUI
import SwiftData

@main
struct CountryAppApp: App {
    var body: some Scene {
        WindowGroup {
            SelectedCountriesView(
                viewModel: CountriesViewModel(
                    api: CountryService(),
                    store: UserDefaultsStore(),
                    locationService: LocationService()
                )
            )
        }
    }
}
