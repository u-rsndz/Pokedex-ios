//
//  AppConfigTests.swift
//  PokeDexTests
//
//  Created by Carlos on 02/10/26.
//

@testable import PokeDex
import XCTest

final class AppConfigTests: XCTestCase {
    func test_defaultConfiguration_hasExpectedValues() {
        let config = AppConfig.defaultConfiguration

        XCTAssertEqual(config.environment, "development")
        XCTAssertEqual(config.api.baseURL, "https://pokeapi.co/api/v2")
        XCTAssertEqual(config.api.pokemonPath, "/pokemon")
        XCTAssertEqual(config.api.defaultLimit, 151)
        XCTAssertEqual(config.api.timeoutInterval, 30.0)
        XCTAssertEqual(config.sprites.baseURL, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon")
        XCTAssertTrue(config.features.enableLogging)
    }

    func test_pokemonListURL_constructsValidURLWithLimitQuery() {
        let config = AppConfig.defaultConfiguration
        let url = config.pokemonListURL

        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.host, "pokeapi.co")
        XCTAssertEqual(url?.path, "/api/v2/pokemon")
        XCTAssertEqual(url?.query, "limit=151")
    }

    func test_spriteURL_constructsCorrectPokemonSpriteURL() {
        let config = AppConfig.defaultConfiguration
        let pikachuURL = config.spriteURL(for: 25)

        XCTAssertNotNil(pikachuURL)
        XCTAssertEqual(
            pikachuURL?.absoluteString,
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"
        )
    }

    func test_loadConfiguration_withValidJSON_decodesProperly() throws {
        let sampleJSON = """
        {
          "environment": "staging",
          "api": {
            "baseURL": "https://staging.pokeapi.co/api/v2",
            "pokemonPath": "/pokemon",
            "defaultLimit": 20,
            "timeoutInterval": 15.0
          },
          "sprites": {
            "baseURL": "https://sprites.example.com"
          },
          "features": {
            "enableLogging": false
          }
        }
        """

        let data = try XCTUnwrap(sampleJSON.data(using: .utf8))
        let decoded = try JSONDecoder().decode(AppConfig.self, from: data)

        XCTAssertEqual(decoded.environment, "staging")
        XCTAssertEqual(decoded.api.baseURL, "https://staging.pokeapi.co/api/v2")
        XCTAssertEqual(decoded.api.defaultLimit, 20)
        XCTAssertEqual(decoded.api.timeoutInterval, 15.0)
        XCTAssertEqual(decoded.sprites.baseURL, "https://sprites.example.com")
        XCTAssertFalse(decoded.features.enableLogging)
    }

    func test_loadConfiguration_whenResourceNotFound_returnsDefaultConfiguration() {
        // Un Bundle vacío/inexistente debe retornar la configuración default sin lanzar excepciones
        let emptyBundle = Bundle(for: type(of: self))
        let config = AppConfig.loadConfiguration(from: emptyBundle)

        XCTAssertEqual(config.api.defaultLimit, AppConfig.defaultConfiguration.api.defaultLimit)
        XCTAssertEqual(config.api.baseURL, AppConfig.defaultConfiguration.api.baseURL)
    }
}
