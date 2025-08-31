//
//  CountryRow.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 31/08/2025.
//
import SwiftUI

struct CountryRow: View {
    let country: Country
    var body: some View {
        HStack {
            if let flag = country.flag, let url = URL(string: flag) {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .scaledToFit()
                         .frame(width: 32, height: 20)
                         .clipShape(RoundedRectangle(cornerRadius: 4))
                         .shadow(radius: 1)
                } placeholder: {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 32, height: 20)
                        .cornerRadius(4)
                }
            }
            
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
        .accessibilityLabel("\(country.name), capital \(country.capital ?? "unknown")")
    }
}
