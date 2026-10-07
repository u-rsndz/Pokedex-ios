//
//  PokeDexTests.swift
//  PokeDexTests
//
//  Created by Uriel on 29/09/26.
//

@testable import PokeDex
import XCTest

// MARK: - Mock Use Case

final class MockFetchPokemonsUseCase: FetchPokemonsUseCaseProtocol {
    var resultToReturn: Result<[PokemonResult], Error>?

    func execute() async throws -> [PokemonResult] {
        if let result = resultToReturn {
            return try result.get()
        }
        throw NSError(domain: "MockError", code: -1, userInfo: nil)
    }
}

// MARK: - ViewModel Unit Tests

@MainActor
final class PokemonListViewModelTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    private var sut: PokemonListViewModel!
    private var mockUseCase: MockFetchPokemonsUseCase!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchPokemonsUseCase()
        sut = PokemonListViewModel(fetchPokemonsUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // MARK: - Async Load Tests

    func test_loadPokemons_success_updatesPokemonsAndSetsLoadingToFalse() async {
        // Given
        let mockPokemons = [
            PokemonResult(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonResult(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
        ]
        mockUseCase.resultToReturn = .success(mockPokemons)

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
        mockUseCase.resultToReturn = .failure(expectedError)

        // When
        await sut.loadPokemons()

        // Then
        XCTAssertTrue(sut.pokemons.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Not Found")
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
