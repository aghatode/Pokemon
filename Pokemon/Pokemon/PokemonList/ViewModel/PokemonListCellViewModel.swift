//
//  PokemonListCellViewModel.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//


import Foundation

class PokemonListCellViewModel: Equatable {
    let id: Int
    let name: String
    let type: String
    let imageURL: String?
    
    init(pokemonModel: PokemonModel) {
        id = pokemonModel.id
        name = pokemonModel.name.capitalized.replacingOccurrences(of: "-", with: " - ")
        imageURL = pokemonModel.sprites?.other?.officialArtwork?.frontDefault ?? pokemonModel.sprites?.frontDefault
        type = pokemonModel.types?.first?.type.name ?? "unknown"
    }
    
    static func == (lhs: PokemonListCellViewModel, rhs: PokemonListCellViewModel) -> Bool {
       return lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type && lhs.imageURL == rhs.imageURL
        
    }
}

