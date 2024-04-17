//
//  PokemonDetailsViewModel.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//

import Foundation



class PokemonDetailsViewModel {
    
    var pokemonModel : PokemonModel?
    let id: Int
    let name: String
    let namedId: String
    let type: String
    let imageURL: String?
    let weight: String
    let height: String
    let stats: [StatsViewModel]
    let types: [String]
    
    
    init(pokemonModel: PokemonModel) {
        self.pokemonModel = pokemonModel
        id = pokemonModel.id
        name = pokemonModel.name.capitalized.replacingOccurrences(of: "-", with: " - ")
        namedId = String(format: "#%03d", pokemonModel.id)
        type = pokemonModel.types?.first?.type.name ?? "unknown"
        imageURL = pokemonModel.sprites?.other?.officialArtwork?.frontDefault
        weight = String(Float(pokemonModel.weight ?? 0) / 10) + " Kg"
        height = String(Float(pokemonModel.height ?? 0) / 10) + " m"
        stats = pokemonModel.stats?.map({ StatsViewModel(stats: $0) }) ?? []
        types = pokemonModel.types?.map({ $0.type.name}) ?? []
        
    }
    
}
