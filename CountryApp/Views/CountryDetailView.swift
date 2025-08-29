//
//  CountryDetailView.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//


import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        List {
            Section("Basics") {
                LabeledContent("Country", value: country.name)
                if let capital = country.capital {
                    LabeledContent("Capital", value: capital)
                }
                if let region = country.region {
                    LabeledContent("Region", value: region)
                }
            }

            Section("Currency") {
                if let currency = country.currencies?.first {
                    LabeledContent("Code", value: currency.code ?? "—")
                    LabeledContent("Name", value: currency.name ?? "—")
                    LabeledContent("Symbol", value: currency.symbol ?? "—")
                } else {
                    Text("No currency data available")
                }
            }
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
