import Foundation
import CoreLocation

@MainActor
final class CountriesViewModel: ObservableObject {
    // Dependencies
    private let api: CountryAPI
    private let store: LocalStore
    
    // Published state
    @Published private(set) var allCountries: [Country] = []
    @Published var selectedCountries: [Country] = [] // up to 5
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var isSelectingInitialCountry: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    init(api: CountryAPI = CountryService(), store: LocalStore = UserDefaultsStore()) {
        self.api = api
        self.store = store
    }
    
    // MARK: - Loading Initial Data
func loadInitialData() async {
        isLoading = true
        await loadCountries()
        restoreSelection()

        // If countries already selected, no need to pick default/nearest
        guard selectedCountries.isEmpty else {
            isLoading = false
            return
        }

        isSelectingInitialCountry = true
        defer {
            isSelectingInitialCountry = false
            isLoading = false
        }

        do {
            if let userLocation = try await LocationService.shared.requestLocation() {
                addNearestCountry(to: userLocation)
            } else {
                addDefaultCountry()
            }
        } catch {
            addDefaultCountry()
        }
    }
    
    // MARK: - Networking
    func loadCountries() async {
        do {
            let countries = try await api.fetchAllCountries()
            allCountries = countries.sorted { $0.name < $1.name }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Selection Management
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else { return }
        guard !selectedCountries.contains(country) else { return }
        selectedCountries.append(country)
        persistSelection()
    }
    
    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0 == country }
        persistSelection()
    }
    
    private func persistSelection() {
        store.saveSelectedCountries(selectedCountries.map { $0.id })
    }
    
    private func restoreSelection() {
        let ids = store.loadSelectedCountries()
        selectedCountries = allCountries.filter { ids.contains($0.id) }
    }
    
    var isWaitingForLocation: Bool {
        isSelectingInitialCountry && selectedCountries.isEmpty
    }
    
    // MARK: - Fallback & Nearest Country
    private func addDefaultCountry() {
        if let france = allCountries.first(where: { $0.name == "France" }) {
            addCountry(france)
        }
    }
    
    private func addNearestCountry(to location: CLLocationCoordinate2D) {
        guard !allCountries.isEmpty else { return }
        
        let nearest = allCountries.min { a, b in
            guard let aCoords = a.latlng, let bCoords = b.latlng else { return false }
            let aDistance = CLLocation(latitude: aCoords[0], longitude: aCoords[1])
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            let bDistance = CLLocation(latitude: bCoords[0], longitude: bCoords[1])
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            return aDistance < bDistance
        }
        
        if let nearest = nearest {
            addCountry(nearest)
        }
    }
    
    // MARK: - Search
    var filteredCountries: [Country] {
        let q = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return allCountries }
        return allCountries.filter { $0.name.localizedCaseInsensitiveContains(q) }
    }
}
