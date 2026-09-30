//
//  PokemonType.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation
import SwiftUI

enum PokemonType: String {
    case normal, fire, water, electric
    case grass, ice, fighting, poison
    case ground, flying, psychic, bug
    case rock, ghost, dragon, dark
    case steel, fairy
    
    var color: Color {
        switch self {
        case .normal:   return .gray
        case .fire:     return .red
        case .water:    return .blue
        case .electric: return .yellow
        case .grass:    return .green
        case .ice:      return .cyan
        case .fighting: return .orange
        case .poison:   return .purple
        case .ground:   return .brown
        case .flying:   return .indigo
        case .psychic:  return .pink
        case .bug:      return .mint
        case .rock:     return .brown
        case .ghost:    return .purple
        case .dragon:   return .teal
        case .dark:     return .black
        case .steel:    return .gray
        case .fairy:    return .pink
        }
    }
}
