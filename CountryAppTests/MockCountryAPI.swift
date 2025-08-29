import Foundation

final class MockCountryAPI: CountryAPI {
    var countriesToReturn: [Country] = []

    func fetchAllCountries() async throws -> [Country] {
        return countriesToReturn
    }
}
