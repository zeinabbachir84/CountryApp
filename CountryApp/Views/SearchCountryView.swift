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
            List(viewModel.filteredCountries) { country in
                Button {
                    viewModel.addCountry(country)
                } label: {
                    HStack {
                        Text(country.name)
                        Spacer()
                        if let code = country.alpha2Code {
                            Text(code).foregroundColor(.secondary)
                        }
                    }
                }
                .disabled(viewModel.selectedCountries.contains(country)
                          || viewModel.selectedCountries.count >= 5)
            }
            .searchable(text: $viewModel.searchQuery)
            .navigationTitle("Add Country")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
