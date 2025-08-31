//
//  SelectedCountriesView.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import SwiftUI

struct SelectedCountriesView: View {
    
    @ObservedObject var viewModel: CountriesViewModel
    @State private var showSearch = false
    @AppStorage("hasSelectedLocations") private var hasSelectedLocations = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isWaitingForLocation && !hasSelectedLocations {
                    // First launch: fetching current location
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Fetching your current location…\nPlease wait")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.isWaitingForLocation {
                    // Returning user: just fetching location
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Fetching your location…")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.isLoading {
                    // Loading countries after fetching location
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Loading countries…")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    // Show error
                    Text("Error: \(message)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.selectedCountries.isEmpty {
                    // No countries selected
                    Text("No countries selected.\nTap + to add up to 5 countries.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Show list of countries
                    List {
                        ForEach(viewModel.selectedCountries) { country in
                            NavigationLink(destination: Text("Detail view for \(country.name)")) {
                                CountryRow(country: country)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { viewModel.selectedCountries[$0] }
                                .forEach(viewModel.removeCountry)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationTitle("Countries")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showSearch = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showSearch) {
                SearchCountryView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                Task {
                    await viewModel.loadInitialData()
                    // Mark first launch as completed
                    hasSelectedLocations = !viewModel.selectedCountries.isEmpty
                }
            }
        }
    }
}

// MARK: - CountryRow

struct CountryRow: View {
    let country: Country
    var body: some View {
        HStack {
            Text(country.name)
                .font(.headline)
            Spacer()
            if let capital = country.capital {
                Text(capital)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

struct SelectedCountriesView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = CountriesViewModel()
        mockViewModel.selectedCountries = [
            Country(
                name: "France",
                alpha2Code: "FR",
                alpha3Code: "FRA",
                capital: "Paris",
                region: "Europe",
                latlng: [46.0, 2.0],
                flag: "https://flagcdn.com/fr.svg",
                currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")]
            ),
            Country(
                name: "United States",
                alpha2Code: "US",
                alpha3Code: "USA",
                capital: "Washington D.C.",
                region: "Americas",
                latlng: [38.0, -97.0],
                flag: "https://flagcdn.com/us.svg",
                currencies: [Currency(code: "USD", name: "US Dollar", symbol: "$")]
            )
        ]
        
        return SelectedCountriesView(viewModel: mockViewModel)
    }
}
