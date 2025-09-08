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
            let sections = countrySections
            List {
                // Section: Already Selected
                if !sections.alreadySelected.isEmpty {
                    Section("Already Selected") {
                        ForEach(sections.alreadySelected) { country in
                            CountryRow(country: country)
                                .opacity(0.5)
                                .disabled(true)
                        }
                    }
                }
                // Section: Available countries
                if !sections.available.isEmpty {
                    Section("Available") {
                        ForEach(sections.available) { country in
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
    private var countrySections: (available: [Country], alreadySelected: [Country]) {
        let selectedIds = Set(viewModel.selectedCountries.map { $0.id })
        var available: [Country] = []
        var alreadySelected: [Country] = []

        for country in viewModel.filteredCountries {
            if selectedIds.contains(country.id) {
                alreadySelected.append(country)
            } else {
                available.append(country)
            }
        }
        return (available, alreadySelected)
    }
}
