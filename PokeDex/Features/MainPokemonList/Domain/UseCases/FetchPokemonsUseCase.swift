//
//  FetchPokemonsUseCase.swift
//  PokeDex
//
//  Created by Carlos on 02/10/26.
//

import Foundation

final class FetchPokemonsUseCase: FetchPokemonsUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [PokemonResult] {
        try await repository.fetchPokemons()
    }
}
