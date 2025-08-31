//
//  SearchSheet.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import SwiftUI

struct SearchCountryView: View {
    @ObservedObject var viewModel: CountriesViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                // Section: Already Selected
                if !alreadySelectedCountries.isEmpty {
                    Section("Already Selected") {
                        ForEach(alreadySelectedCountries) { country in
                            CountryRow(country: country)
                                .opacity(0.5)
                                .disabled(true)
                        }
                    }
                }
                
                // Section: Available countries
                if !availableCountries.isEmpty {
                    Section("Available") {
                        ForEach(availableCountries) { country in
                            Button {
                                viewModel.addCountry(country)
                                dismiss() // ✅ auto-close after adding
                            } label: {
                                CountryRow(country: country)
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .navigationTitle("Add Country")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .bold()
                }
            }
        }
    }

    // MARK: - Helpers
    private var availableCountries: [Country] {
        viewModel.filteredCountries.filter { country in
            !viewModel.selectedCountries.contains(country) &&
            viewModel.selectedCountries.count < 5
        }
    }

    private var alreadySelectedCountries: [Country] {
        viewModel.filteredCountries.filter { viewModel.selectedCountries.contains($0) }
    }
}
