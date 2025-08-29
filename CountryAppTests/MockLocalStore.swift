final class MockLocalStore: LocalStore {
    var savedIds: [String] = []

    func saveSelectedCountries(_ ids: [String]) {
        savedIds = ids
    }

    func loadSelectedCountries() -> [String] {
        return savedIds
    }
}
