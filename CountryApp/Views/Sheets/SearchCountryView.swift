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
                let isDisabled = viewModel.selectedCountries.contains(country)
                                || viewModel.selectedCountries.count >= 5
                Button {
                    viewModel.addCountry(country)
                } label: {
                    CountryRow(country: country)
                }
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1.0)
            }
            .searchable(text: $viewModel.searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always))
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
}
