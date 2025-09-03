//
//  CountryAPI.swift
//  CountryApp
//

import Foundation

protocol CountryAPI {
    func fetchAllCountries() async throws -> [Country]
}

enum CountryError: LocalizedError {
    case network
    case decoding
    case locationDenied
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .network: return "Failed to fetch countries. Please try again."
        case .decoding: return "Data could not be decoded."
        case .locationDenied: return "Location permission denied."
        case .unknown: return "An unexpected error occurred."
        }
    }
}

struct CountryDTO: Codable {
    let name: String
    let alpha2Code: String?
    let alpha3Code: String?
    let capital: String?
    let region: String?
    let latlng: [Double]?
    let currencies: [Currency]?

    var pngFlagURL: String? {
        guard let code = alpha2Code?.lowercased() else { return nil }
        return "https://flagcdn.com/w320/\(code).png"
    }
}

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

        let dtos = try JSONDecoder().decode([CountryDTO].self, from: data)
        return dtos.map { dto in
            Country(
                name: dto.name,
                alpha2Code: dto.alpha2Code,
                alpha3Code: dto.alpha3Code,
                capital: dto.capital,
                region: dto.region,
                latlng: dto.latlng,
                currencies: dto.currencies
            )
        }
    }
}

