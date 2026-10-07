//
//  PokemonDetailViewModel.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation
import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    let pokemonUrl: String
    let pokemonName: String

    @Published var detail: PokemonDetail?
    @Published var isLoading = true
    @Published var errorMessage: String?

    private let service: PokemonServiceProtocol

    init(pokemonUrl: String, pokemonName: String, service: PokemonServiceProtocol = PokemonService()) {
        self.pokemonUrl = pokemonUrl
        self.pokemonName = pokemonName
        self.service = service
    }

    var currentPokemonResult: PokemonResult {
        PokemonResult(name: pokemonName, url: pokemonUrl)
    }

    var primaryTypeColor: Color {
        guard let typeName = detail?.types.first?.type.name.lowercased(),
              let pokemonType = PokemonType(rawValue: typeName)
        else {
            return .gray
        }
        return pokemonType.color
    }

    @MainActor
    func loadDetails() async {
        isLoading = true
        errorMessage = nil

        do {
            detail = try await service.fetchDetails(from: pokemonUrl)
        } catch {
            errorMessage = "Failed to load: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
