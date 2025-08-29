import Foundation

protocol LocalStore {
    func saveSelectedCountries(_ ids: [String])
    func loadSelectedCountries() -> [String]
}

final class UserDefaultsStore: LocalStore {
    private let key = "selected_countries_ids"

    func saveSelectedCountries(_ ids: [String]) {
        UserDefaults.standard.set(ids, forKey: key)
    }

    func loadSelectedCountries() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
