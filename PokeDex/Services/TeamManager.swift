//
//  TeamManager.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation

final class TeamManager: ObservableObject {
    private let key = "SavedPokemonTeam"

    @Published var team: [PokemonResult] = [] {
        didSet {
            if team.count > 6 {
                team = Array(team.prefix(6))
                return
            }
            save()
        }
    }

    init() {
        load()
    }

    func add(_ pokemon: PokemonResult) {
        guard !team.contains(where: { $0.id == pokemon.id }), team.count < 6 else { return }
        team.append(pokemon)
    }

    func remove(at offsets: IndexSet) {
        team.remove(atOffsets: offsets)
    }

    func isAlreadyInTeam(_ pokemonId: Int) -> Bool {
        team.contains(where: { $0.id == pokemonId })
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(team) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([PokemonResult].self, from: data) {
            team = decoded
        }
    }
}
