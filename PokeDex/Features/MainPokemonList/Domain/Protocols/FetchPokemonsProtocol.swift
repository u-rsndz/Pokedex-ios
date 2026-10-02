//
//  FetchPokemonsProtocol.swift
//  PokeDex
//
//  Created by Carlos on 02/10/26.
//

import Foundation

protocol FetchPokemonsUseCaseProtocol {
    func execute() async throws -> [PokemonResult]
}
