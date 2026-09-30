//
//  PokemonTeamView.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//
import Foundation
import SwiftUI

struct PokemonTeamView: View {
    @EnvironmentObject private var teamManager: TeamManager
    
    var body: some View {
        NavigationStack {
            Group {
                if teamManager.team.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "house")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No Pokémon on your team")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Go to the Pokédex tab and tap '+' to add Pokémon.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(teamManager.team) { pokemon in
                            PokemonRowView(pokemon: pokemon)
                        }
                        .onDelete(perform: teamManager.remove)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Team")
                        Text("\(teamManager.team.count) / 6")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
}
