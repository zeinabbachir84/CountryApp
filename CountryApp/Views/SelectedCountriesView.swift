//
//  MainView.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = CountriesViewModel()
    @State private var showSearch = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView("Loading countries…")
                } else if let message = viewModel.errorMessage {
                    Text("Error: \(message)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.selectedCountries.isEmpty {
                    Text("No countries selected.\nTap + to add up to 5 countries.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.selectedCountries) { country in
                            NavigationLink(value: country) {
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
            .navigationTitle("Countries")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(viewModel.selectedCountries.count >= 5)
                }
            }
            .sheet(isPresented: $showSearch) {
                SearchSheet(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .task {
                await viewModel.bootstrap()
            }
            .navigationDestination(for: Country.self) { country in
                CountryDetailView(country: country)
            }
        }
    }
}

struct CountryRow: View {
    let country: Country
    var body: some View {
        HStack {
            Text(country.name).font(.headline)
            Spacer()
            if let capital = country.capital {
                Text(capital).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}
