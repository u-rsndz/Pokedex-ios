//
//  ContentView.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import SwiftUI //

struct ContentView: View {
    @StateObject private var teamManager = TeamManager()

    var body: some View {
        TabView {
            PokemonListView()
                .tabItem {
                    Label("Pokédex", systemImage: "magnifyingglass")
                }

            PokemonTeamView()
                .tabItem {
                    Label("Team", systemImage: "house.fill")
                }
        }
        .environmentObject(teamManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
