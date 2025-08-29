import Foundation

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
    @Published var errorMessage: String?

    // MARK: - Initialization
    init(api: CountryAPI = CountryService(), store: LocalStore = UserDefaultsStore()) {
        self.api = api
        self.store = store
    }

    // MARK: - Bootstrapping
    func bootstrap() async {
        await loadCountries()
        restoreSelection()
        // GPS-based default country will be added later
    }

    // MARK: - Networking
    func loadCountries() async {
        isLoading = true
        defer { isLoading = false }
        
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

    // MARK: - Search
    var filteredCountries: [Count]()
