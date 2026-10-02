//
//  PokemonListView.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation
import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel(fetchPokemonsUseCase:
                                                                FetchPokemonsUseCase(repository:
                                                                                        PokemonRepository(remoteDataManager:
                                                                                                            PokemonRemoteDataManager())))
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Pokémon...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.filteredPokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemonUrl: pokemon.url, pokemonName: pokemon.name)) {
                            PokemonRowView(pokemon: pokemon)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .searchable(text: $viewModel.searchText, prompt: "Search Pokémon")
            .task {
                await viewModel.loadPokemons()
            }
        }
    }
}
