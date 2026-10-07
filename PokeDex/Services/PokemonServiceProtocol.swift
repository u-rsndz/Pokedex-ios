//
//  PokemonServiceProtocol.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation

/// borrar
protocol PokemonServiceProtocol {
    func fetchPokemons() async throws -> [PokemonResult]
    func fetchDetails(from urlString: String) async throws -> PokemonDetail
}

/// tu
protocol PokemonDetailServiceProtocol {
    func fetchDetails(from urlString: String) async throws -> PokemonDetail
}
