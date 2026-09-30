//
//  PokemonListViewModel.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation



final class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [PokemonResult] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let service: PokemonServiceProtocol
    
    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }
    
    var filteredPokemons: [PokemonResult] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @MainActor
    func loadPokemons() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemons = try await service.fetchPokemons()
        } catch {
            errorMessage = "Failed to load: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
