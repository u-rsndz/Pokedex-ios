//
//  PokeDexTests.swift
//  PokeDexTests
//
//  Created by Uriel on 29/09/26.
//

import XCTest
@testable import PokeDex

// MARK: - Mock Service
final class MockPokemonService: PokemonServiceProtocol {
    var resultToReturn: Result<[PokemonResult], Error>?
    var detailResultToReturn: Result<PokemonDetail, Error>?

    func fetchPokemons() async throws -> [PokemonResult] {
        if let result = resultToReturn {
            return try result.get()
        }
        throw NSError(domain: "MockError", code: -1, userInfo: nil)
    }

    func fetchDetails(from urlString: String) async throws -> PokemonDetail {
        if let result = detailResultToReturn {
            return try result.get()
        }
        throw NSError(domain: "MockError", code: -1, userInfo: nil)
    }
}

// MARK: - ViewModel Unit Tests
final class PokemonListViewModelTests: XCTestCase {
    private var sut: PokemonListViewModel!
    private var mockService: MockPokemonService!

    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        sut = PokemonListViewModel(service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Async Load Tests

    func test_loadPokemons_success_updatesPokemonsAndSetsLoadingToFalse() async {
        // Given
        let mockPokemons = [
            PokemonResult(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonResult(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
        ]
        mockService.resultToReturn = .success(mockPokemons)

        // When
        await sut.loadPokemons()

        // Then
        XCTAssertEqual(sut.pokemons.count, 2)
        XCTAssertEqual(sut.pokemons.first?.name, "Pikachu")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadPokemons_failure_setsErrorMessageAndLoadingToFalse() async {
        // Given
        let expectedError = NSError(domain: "Network", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        mockService.resultToReturn = .failure(expectedError)

        // When
        await sut.loadPokemons()

        // Then
        XCTAssertTrue(sut.pokemons.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Failed to load: Not Found")
    }

    // MARK: - Search Filtering Tests

    func test_filteredPokemons_whenSearchTextIsEmpty_returnsAllPokemons() {
        // Given
        sut.pokemons = [
            PokemonResult(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonResult(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
        ]
        sut.searchText = ""

        // Then
        XCTAssertEqual(sut.filteredPokemons.count, 2)
    }

    func test_filteredPokemons_whenSearchTextMatches_returnsFilteredResultsCaseInsensitive() {
        // Given
        sut.pokemons = [
            PokemonResult(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonResult(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonResult(name: "Raichu", url: "https://pokeapi.co/api/v2/pokemon/26/")
        ]

        // When
        sut.searchText = "chu"

        // Then
        XCTAssertEqual(sut.filteredPokemons.count, 2)
        XCTAssertEqual(sut.filteredPokemons.map { $0.name }, ["Pikachu", "Raichu"])
    }
}
