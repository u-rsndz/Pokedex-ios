//
//  PokemonDetailView.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//
import Foundation
import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    @EnvironmentObject private var teamManager: TeamManager

    init(pokemonUrl: String, pokemonName: String) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemonUrl: pokemonUrl, pokemonName: pokemonName))
    }

    private var isAlreadyInTeam: Bool {
        teamManager.isAlreadyInTeam(viewModel.currentPokemonResult.id)
    }

    private var isTeamFull: Bool {
        teamManager.team.count >= 6
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    viewModel.primaryTypeColor
                        .opacity(0.30)

                    if viewModel.isLoading {
                        ProgressView("Loading details...")
                            .padding(.top, 100)
                            .padding(.bottom, 60)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 100)
                            .padding(.bottom, 60)
                    } else if let detail = viewModel.detail {
                        if let frontDefault = detail.sprites.frontDefault,
                           let imageURL = URL(string: frontDefault) {
                            VStack {
                                AsyncImage(url: imageURL) { phase in
                                    switch phase {
                                    case let .success(image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 220, height: 220)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.secondary)
                                    case .empty:
                                        ProgressView()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                Text(viewModel.pokemonName.capitalized)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                // DETAILS CONTENT SECTION
                if let detail = viewModel.detail {
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            StatView(title: "Height", value: "\(detail.height)")
                            StatView(title: "Weight", value: "\(detail.weight)")
                            StatView(
                                title: "Types",
                                value: detail.types.map { $0.type.name.capitalized }.joined(separator: ", ")
                            )
                        }
                        Spacer(minLength: 20)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .systemBackground))
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if !isTeamFull {
                    Button {
                        teamManager.add(viewModel.currentPokemonResult)
                    } label: {
                        Image(systemName: isAlreadyInTeam ? "checkmark" : "plus")
                            .animation(.default, value: isAlreadyInTeam)
                    }
                    .tint(.white)
                }
            }
        }
        .id("detailToolbar")
        .task {
            await viewModel.loadDetails()
        }
    }
}
