
# 🌍 CountryApp

CountryApp is a SwiftUI-based iOS application that allows users to search, select, and view details about countries.
It integrates location services to fetch the user’s current location and provides a clean, modular UI architecture.

---

## ✨ Features
- Search and select up to **5 countries**
- View **country details** (flag, capital, region, currencies, etc.)
- **Location-based startup**: fetches the user’s current location
- **Fallback behavior**: if location access is declined, defaults to **Lebanon**
- Modular SwiftUI components for reusability
- Snapshot & unit test coverage

---

## 🛠️ Project Structure
```
CountryApp/
 ├── Views/
 │    ├── Components/
 │    │     ├── CountryRow.swift
 │    │     ├── LoadingStateView.swift
 │    │     └── EmptyStateView.swift
 │    └── Screens/
 │          └── SelectedCountriesView.swift
 ├── Models/
 ├── ViewModels/
 └── Resources/
      ├── Assets.xcassets
      └── LaunchScreen.storyboard
```

---

## 🚀 Getting Started

### Requirements
- Xcode 15+
- iOS 17+
- Swift 5.9+
- Simulator or physical iOS device

### Installation
1. Clone the repository:
```bash
git clone https://github.com/zeinabbachir84/CountryApp.git
cd CountryApp
```
2. Open `CountryApp.xcodeproj` in Xcode
3. Build & Run (`Cmd + R`) on simulator or device

---

## 🧪 Testing
Run all tests with:
```bash
Cmd + U
```

## 🧩 Known Issues
- First-time snapshot tests may fail until reference images are recorded
- Location permission prompts can interfere with automated tests

---

### Notes
- Launch Screen uses a storyboard due to iOS requirements. All other screens are implemented in SwiftUI as requested in the task guidelines.

## 👩‍💻 Author
- **Zeinab Bachir**
