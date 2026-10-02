//
//  MainPokemonListServiceProtocol.swift
//  PokeDex
//
//  Created by Carlos on 02/10/26.
//

import Foundation

protocol MainPokemonListServiceProtocol {
    func fetchPokemons() async throws -> [PokemonResult]
}
