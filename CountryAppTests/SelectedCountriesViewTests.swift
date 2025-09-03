//
//  SelectedCountriesViewTests.swift
//  CountryAppTests
//
//  Created by Zeinab Bachir on 29/08/2025.
//

import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting
@testable import CountryApp

@MainActor
final class SelectedCountriesViewTests: XCTestCase {

    // MARK: - ViewInspector Tests

    func testListShowsCorrectNumberOfCountries() throws {
        // Arrange
        let viewModel = CountriesViewModel()
        viewModel.selectedCountries = [
            makeDummyCountry(name: "France"),
            makeDummyCountry(name: "USA")
        ]
        viewModel.isWaitingForLocation = false
        viewModel.isLoading = false

        let view = SelectedCountriesView(viewModel: viewModel)

        // Act
        let inspectedView = try view.inspect()
        
        // Access NavigationStack -> ZStack -> List (index 0, since List is first visible child)
        let list = try inspectedView.navigationStack().zStack().list(0)
        let forEach = try list.forEach(0)

        // Assert
        XCTAssertEqual(forEach.count, 2)
    }

    func testLoadingStateViewShownWhenLoading() throws {
        let viewModel = CountriesViewModel(
            api: MockCountryAPI(),
            store: MockLocalStore(),
            locationService: MockLocationService()
        )
        viewModel.isLoading = true

        let view = SelectedCountriesView(viewModel: viewModel)

        // Inspect ZStack for LoadingStateView
        let loadingView = try view.inspect()
            .navigationStack()
            .zStack()
            .find(LoadingStateView.self)

        XCTAssertNotNil(loadingView)
    }

    // MARK: - Snapshot Tests

    func testSelectedCountriesViewLightMode() {
        let viewModel = CountriesViewModel()
        viewModel.selectedCountries = [
            makeDummyCountry(name: "France"),
            makeDummyCountry(name: "USA")
        ]

        let view = SelectedCountriesView(viewModel: viewModel)
            .frame(width: 375, height: 812)
            .environment(\.colorScheme, .light)

        assertSnapshot(of: view, as: .image)
    }

    func testSelectedCountriesViewDarkMode() {
        let viewModel = CountriesViewModel()
        viewModel.selectedCountries = [
            makeDummyCountry(name: "France")
        ]

        let view = SelectedCountriesView(viewModel: viewModel)
            .frame(width: 375, height: 812)
            .environment(\.colorScheme, .dark)

        assertSnapshot(of: view, as: .image)
    }

    // MARK: - Helpers

    private func makeDummyCountry(name: String) -> Country {
        Country(
            name: name,
            alpha2Code: String(name.prefix(2)).uppercased(),
            alpha3Code: String(name.prefix(3)).uppercased(),
            capital: "Capital",
            region: "Region",
            latlng: [],
            currencies: []
        )
    }
}
