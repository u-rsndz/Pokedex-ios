//
//  PokemonRowView.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation
import SwiftUI

struct PokemonRowView: View {
    let pokemon: PokemonResult
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 50, height: 50)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(pokemon.name.capitalized)
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}
