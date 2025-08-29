import XCTest
@testable import YourAppModuleName

@MainActor
final class CountriesViewModelTests: XCTestCase {

    func testAddAndRemoveCountry() async {
        let mockAPI = MockCountryAPI()
        let mockStore = MockLocalStore()
        let viewModel = CountriesViewModel(api: mockAPI, store: mockStore)

        let france = Country(name: "France", alpha2Code: "FR", alpha3Code: "FRA",
                             capital: "Paris", region: "Europe", latlng: [46.0, 2.0],
                             flag: nil, currencies: nil)

        // Add country
        viewModel.addCountry(france)
        XCTAssertTrue(viewModel.selectedCountries.contains(france))
        XCTAssertEqual(mockStore.savedIds, [france.id])

        // Remove country
        viewModel.removeCountry(france)
        XCTAssertFalse(viewModel.selectedCountries.contains(france))
        XCTAssertEqual(mockStore.savedIds, [])
    }

    func testAddCountryMaxLimit() async {
        let mockAPI = MockCountryAPI()
        let mockStore = MockLocalStore()
        let viewModel = CountriesViewModel(api: mockAPI, store: mockStore)

        for i in 1...6 {
            let country = Country(name: "Country\(i)", alpha2Code: nil, alpha3Code: nil,
                                  capital: nil, region: nil, latlng: nil, flag: nil, currencies: nil)
            viewModel.addCountry(country)
        }

        XCTAssertEqual(viewModel.selectedCountries.count, 5) // max limit
    }

    func testFilteredCountries() async {
        let france = Country(name: "France", alpha2Code: "FR", alpha3Code: "FRA",
                             capital: "Paris", region: "Europe", latlng: nil, flag: nil,
                             currencies: nil)
        let usa = Country(name: "United States", alpha2Code: "US", alpha3Code: "USA",
                          capital: "Washington D.C.", region: "Americas", latlng: nil,
                          flag: nil, currencies: nil)

        let mockAPI = MockCountryAPI()
        mockAPI.countriesToReturn = [france, usa]

        let viewModel = CountriesViewModel(api: mockAPI, store: MockLocalStore())
        await viewModel.loadCountries()

        viewModel.searchQuery = "fr"
        XCTAssertEqual(viewModel.filteredCountries, [france])
    }
}
