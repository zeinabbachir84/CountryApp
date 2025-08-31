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
                    LoadingStateView(
                        systemImage: "location.circle",
                        text: "Fetching your current location…\nPlease wait"
                    )
                } else if viewModel.isWaitingForLocation {
                    LoadingStateView(
                        systemImage: "location.circle",
                        text: "Fetching your location…"
                    )
                } else if viewModel.isLoading {
                    LoadingStateView(
                        systemImage: "globe.europe.africa",
                        text: "Loading countries…"
                    )
                } else if let message = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        EmptyStateView(
                            systemImage: "exclamationmark.triangle",
                            text: "Error:\n\(message)",
                            color: .red
                        )
                        Button {
                            Task { await viewModel.loadInitialData() }
                        } label: {
                            Label("Retry", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if viewModel.selectedCountries.isEmpty {
                    EmptyStateView(
                        systemImage: "globe",
                        text: "No countries selected.\nTap + to add up to 5 countries."
                    )
                } else {
                    List {
                        ForEach(viewModel.selectedCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                CountryRow(country: country)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { viewModel.selectedCountries[$0] }
                                .forEach(viewModel.removeCountry)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image("icon")
                            .foregroundColor(.accentColor)
                        Text("Countries")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showSearch = true } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add a country")
                    .disabled(viewModel.selectedCountries.count >= 5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showSearch) {
                SearchCountryView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                Task {
                    await viewModel.loadInitialData()
                    hasSelectedLocations = !viewModel.selectedCountries.isEmpty
                }
            }
        }
    }
}
