//
//  CountryAPI.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 29/08/2025.
//
// Note: For this small project, we keep the `CountryAPI` protocol
// and its implementation `CountryService` in the same file.
// This keeps the code simple and easy to navigate for reviewers.
// In larger projects with multiple implementations, separating
// the protocol into its own file would be recommended.
//


import Foundation

protocol CountryAPI {
    func fetchAllCountries() async throws -> [Country]
}

final class CountryService: CountryAPI {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchAllCountries() async throws -> [Country] {
        // Fetch only the needed fields to reduce payload
        let url = URL(string: "https://restcountries.com/v2/all?fields=name,alpha2Code,alpha3Code,capital,region,latlng,flag,currencies")!
        let (data, response) = try await session.data(from: url)
        
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Country].self, from: data)
    }
}
