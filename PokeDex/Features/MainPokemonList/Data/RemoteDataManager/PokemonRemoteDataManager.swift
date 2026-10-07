//
//  PokemonRemoteDataManager.swift
//  PokeDex
//
//  Created by Carlos on 02/10/26.
//

import Foundation

final class PokemonRemoteDataManager: PokemonRemoteDataManagerProtocol {
    func fetchPokemons() async throws -> [PokemonResult] {
        guard let url = AppConfig.shared.pokemonListURL else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(
            PokemonResponse.self,
            from: data
        )

        return response.results
    }
}
