//
//  PokemonService.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation

final class PokemonService: PokemonServiceProtocol {
    func fetchPokemons() async throws -> [PokemonResult] {
        guard let url = AppConfig.shared.pokemonListURL else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonResponse.self, from: data)
        return response.results
    }

    func fetchDetails(from urlString: String) async throws -> PokemonDetail {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(PokemonDetail.self, from: data)
    }
}
