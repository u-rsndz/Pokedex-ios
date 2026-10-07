//
//  PokemonDetail.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeEntry]
    let sprites: Sprites

    struct Sprites: Codable {
        let frontDefault: String?
    }

    struct TypeEntry: Codable {
        let slot: Int
        let type: TypeInfo
    }

    struct TypeInfo: Codable {
        let name: String
        let url: String
    }
}
