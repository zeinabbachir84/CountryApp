import XCTest
import CoreLocation
@testable import CountryApp

@MainActor
final class CountriesViewModelTests: XCTestCase {

    var mockAPI: MockCountryAPI!
    var mockStore: MockLocalStore!
    var mockLocation: MockLocationService!
    var viewModel: CountriesViewModel!

    override func setUp() {
        super.setUp()
        mockAPI = MockCountryAPI()
        mockStore = MockLocalStore()
        mockLocation = MockLocationService()
        viewModel = CountriesViewModel(api: mockAPI, store: mockStore, locationService: mockLocation)
    }

    override func tearDown() {
        mockAPI = nil
        mockStore = nil
        mockLocation = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Load Countries

    func testLoadInitialDataFetchesCountries() async {
        let lebanon = makeDummyCountry(name: "Lebanon")
        mockAPI.countriesToReturn = [lebanon]

        await viewModel.loadInitialData()

        XCTAssertEqual(viewModel.allCountries.count, 1)
        XCTAssertEqual(viewModel.allCountries.first?.name, "Lebanon")
    }

    func testLoadInitialDataAddsNearestCountry() async {
        let lebanon = makeDummyCountry(name: "Lebanon", latlng: [46, 2])
        mockAPI.countriesToReturn = [lebanon]
        mockLocation.coordinateToReturn = CLLocationCoordinate2D(latitude: 46, longitude: 2)

        await viewModel.loadInitialData()

        XCTAssertTrue(viewModel.selectedCountries.contains(lebanon))
    }

    func testLoadInitialDataAddsDefaultCountryIfLocationFails() async {
        let lebanon = makeDummyCountry(name: "Lebanon")
        mockAPI.countriesToReturn = [lebanon]
        mockLocation.shouldThrowError = true

        await viewModel.loadInitialData()

        XCTAssertTrue(viewModel.selectedCountries.contains(lebanon))
    }

    // MARK: - Selection

    func testSelectCountryAddsToSelected() {
        let lebanon = makeDummyCountry(name: "Lebanon")
        viewModel.addCountry(lebanon)

        XCTAssertTrue(viewModel.selectedCountries.contains(lebanon))
        XCTAssertEqual(mockStore.savedIds, [lebanon.id])
    }

    func testRemoveCountryFromSelected() {
        let lebanon = makeDummyCountry(name: "Lebanon")
        viewModel.addCountry(lebanon)
        viewModel.removeCountry(lebanon)

        XCTAssertFalse(viewModel.selectedCountries.contains(lebanon))
        XCTAssertEqual(mockStore.savedIds, [])
    }

    // MARK: - Search

    func testFilteredCountriesMatchesSearchQuery() {
        let france = makeDummyCountry(name: "France")
        let usa = makeDummyCountry(name: "USA")
        viewModel.allCountries = [france, usa]

        viewModel.searchQuery = "fra"
        XCTAssertEqual(viewModel.filteredCountries, [france])

        viewModel.searchQuery = "us"
        XCTAssertEqual(viewModel.filteredCountries, [usa])
    }

    func testFilteredCountriesReturnsAllIfQueryEmpty() {
        let france = makeDummyCountry(name: "France")
        let usa = makeDummyCountry(name: "USA")
        viewModel.allCountries = [france, usa]

        viewModel.searchQuery = ""
        XCTAssertEqual(viewModel.filteredCountries.count, 2)
    }

    // MARK: - Helpers

    private func makeDummyCountry(name: String, latlng: [Double] = []) -> Country {
        Country(
            name: name,
            alpha2Code: String(name.prefix(2)).uppercased(),
            alpha3Code: String(name.prefix(3)).uppercased(),
            capital: nil,
            region: "TestRegion",
            latlng: latlng,
            flag: nil,
            currencies: []
        )
    }
}

// MARK: - Mocks

final class MockCountryAPI: CountryAPI {
    var countriesToReturn: [Country] = []
    var shouldThrowError = false

    func fetchAllCountries() async throws -> [Country] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return countriesToReturn
    }
}

final class MockLocalStore: LocalStore {
    var savedIds: [String] = []

    func saveSelectedCountries(_ ids: [String]) {
        savedIds = ids
    }

    func loadSelectedCountries() -> [String] {
        savedIds
    }
}

final class MockLocationService: LocationProviding {
    var coordinateToReturn: CLLocationCoordinate2D? = nil
    var shouldThrowError = false

    func requestLocation() async throws -> CLLocationCoordinate2D? {
        if shouldThrowError { throw URLError(.notConnectedToInternet) }
        return coordinateToReturn
    }
}
