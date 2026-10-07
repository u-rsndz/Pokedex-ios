//
//  PokemonRepository.swift
//  PokeDex
//
//  Created by Carlos on 02/10/26.
//

import Foundation

final class PokemonRepository: PokemonRepositoryProtocol {
    private let remoteDataManager: PokemonRemoteDataManagerProtocol

    init(remoteDataManager: PokemonRemoteDataManagerProtocol) {
        self.remoteDataManager = remoteDataManager
    }

    func fetchPokemons() async throws -> [PokemonResult] {
        try await remoteDataManager.fetchPokemons()
    }
}
