//
//  PokemonListModel.swift
//  Pokemon
//
//  Created by Aditi Patil on 13/04/2024.
//

// MARK: - MainModel
struct PokemonListModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ResultModel]?
}

// MARK: - Result
struct ResultModel: Codable, Equatable {
    let name: String?
    let url: String?
}
