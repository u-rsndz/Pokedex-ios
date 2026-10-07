//
//  PokemonListViewModel.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//
// dejar de usar este y usar el de aqui xd , ejecutar el use case
// gererar el protocolo y el use case para solicitar los pokes
// tu use case de tu capa de dominio se lo va a soliitar al repositorio
// el repositorio se lo va a solicitar al remot data manager
import Foundation

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [PokemonResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    private let fetchPokemonsUseCase: FetchPokemonsUseCaseProtocol

    init(fetchPokemonsUseCase: FetchPokemonsUseCaseProtocol) {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
    }

    var filteredPokemons: [PokemonResult] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func loadPokemons() async {
        isLoading = true
        errorMessage = nil

        do {
            pokemons = try await fetchPokemonsUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
