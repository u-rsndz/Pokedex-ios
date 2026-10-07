//
//  AppConfig.swift
//  PokeDex
//
//  Created by Carlos on 02/10/26.
//

import Foundation

// MARK: - App Configuration Models

public struct APIConfig: Codable, Sendable {
    public let baseURL: String
    public let pokemonPath: String
    public let defaultLimit: Int
    public let timeoutInterval: TimeInterval

    public init(
        baseURL: String,
        pokemonPath: String,
        defaultLimit: Int,
        timeoutInterval: TimeInterval
    ) {
        self.baseURL = baseURL
        self.pokemonPath = pokemonPath
        self.defaultLimit = defaultLimit
        self.timeoutInterval = timeoutInterval
    }
}

public struct SpritesConfig: Codable, Sendable {
    public let baseURL: String

    public init(baseURL: String) {
        self.baseURL = baseURL
    }
}

public struct FeaturesConfig: Codable, Sendable {
    public let enableLogging: Bool

    public init(enableLogging: Bool) {
        self.enableLogging = enableLogging
    }
}

public struct AppConfig: Codable, Sendable {
    public let environment: String
    public let api: APIConfig
    public let sprites: SpritesConfig
    public let features: FeaturesConfig

    public init(
        environment: String,
        api: APIConfig,
        sprites: SpritesConfig,
        features: FeaturesConfig
    ) {
        self.environment = environment
        self.api = api
        self.sprites = sprites
        self.features = features
    }
}

// MARK: - Defaults & Loader

public extension AppConfig {
    /// Configuración de respaldo en caso de que config.json no esté presente en el bundle (e.g. previews o tests).
    static let defaultConfiguration = AppConfig(
        environment: "development",
        api: APIConfig(
            baseURL: "https://pokeapi.co/api/v2",
            pokemonPath: "/pokemon",
            defaultLimit: 151,
            timeoutInterval: 30.0
        ),
        sprites: SpritesConfig(
            baseURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon"
        ),
        features: FeaturesConfig(
            enableLogging: true
        )
    )

    /// Instancia global compartida cargada desde config.json en el Bundle principal.
    static let shared: AppConfig = loadConfiguration()

    /// Carga la configuración desde un bundle especificado con soporte de fallback.
    static func loadConfiguration(from bundle: Bundle = .main) -> AppConfig {
        guard let url = bundle.url(forResource: "config", withExtension: "json") else {
            return defaultConfiguration
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(AppConfig.self, from: data)
        } catch {
            return defaultConfiguration
        }
    }
}

// MARK: - URL Helpers

public extension AppConfig {
    /// URL completa para solicitar la lista de pokémon utilizando el límite por defecto.
    var pokemonListURL: URL? {
        guard var components = URLComponents(string: api.baseURL + api.pokemonPath) else {
            return nil
        }
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(api.defaultLimit)")
        ]
        return components.url
    }

    /// Construye la URL para el sprite oficial de un pokémon dado su identificador numérico.
    func spriteURL(for pokemonId: Int) -> URL? {
        URL(string: "\(sprites.baseURL)/\(pokemonId).png")
    }
}
