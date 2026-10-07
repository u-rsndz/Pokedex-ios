//
//  PokemonResult.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation

struct PokemonResult: Codable, Identifiable, Equatable {
    let name: String
    let url: String

    var id: Int {
        let components = url.split(separator: "/").compactMap { Int($0) }
        return components.last ?? 0
    }
}
