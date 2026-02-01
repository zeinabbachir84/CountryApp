//
//  CountryService.swift
//  CountryApp
//

import Foundation

final class CountryService: CountryAPI {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchAllCountries() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v2/all?fields=name,alpha2Code,alpha3Code,capital,region,latlng,currencies")!
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw CountryError.network
        }

        do {
            let dtos = try JSONDecoder().decode([CountryDTO].self, from: data)
            return dtos.map { $0.toEntity() }
        } catch {
            throw CountryError.decoding
        }
    }
}

