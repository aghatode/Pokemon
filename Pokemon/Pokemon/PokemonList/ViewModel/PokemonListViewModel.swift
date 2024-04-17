//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Aditi Patil on 13/04/2024.
//

import Foundation

final class PokemonListViewModel: NSObject {
    var pokemons:PokemonListModel?
    var pokemonModels: [PokemonModel]? = []
    var cellViewModel: [PokemonListCellViewModel] = []
    var nextPageURL: URL?
    var nextOffset: Int?
    var isSearching: Bool = false
    
    let networkManager = NetworkManager()
    override init() {
        super.init()
    }
    
    //Gets list of Pokemons
    func fetchPokemon(offset: Int, onSuccess: (()->Void)?, onError: (()->Void)?){
      self.getPokemons(
            offset: offset,
            onSuccess: { pokemonList, pokemonModelList in
                
                self.pokemons = pokemonList
                self.pokemonModels?.append(contentsOf: pokemonModelList)
                
                self.nextPageURL = URL(string: pokemonList.next ?? "")
                if let urlComponents = URLComponents(string: pokemonList.next ?? "") {
                    let queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
                    self.nextOffset = Int(queryItems.first(where: { $0.name == "offset" })?.value ?? "")
                }else{
                    self.nextOffset = nil
                }
                
                self.cellViewModel.append(contentsOf: pokemonModelList.map({ return PokemonListCellViewModel(pokemonModel: $0) }))
                onSuccess?()
            },
            onError: {
                onError?()
            }
        )
    }
    
    //Gets pokemon details for a specific pokemon
    func getPokemons(offset: Int, onSuccess: ((PokemonListModel, [PokemonModel]) -> Void)?, onError: (() -> Void)?) {
        networkManager.getPokemons(
            offset: offset,
            onSuccess: { mainModel in
                var pokemons: [PokemonModel] = []
                let group = DispatchGroup()
                mainModel.results?.forEach { pokemon in
                    if let pokemonName = pokemon.name {
                        group.enter()
                        self.networkManager.searchPokemon(name: pokemonName) { pokemonModel in
                            pokemons.append(pokemonModel)
                            group.leave()
                        } onError: {
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    pokemons.sort(by: { $0.id < $1.id })
                    onSuccess?(mainModel, pokemons)
                }
            },
            onError: {
                onError?()
            }
        )
    }
    
    func searchPokemon(name: String, onSuccess: (()->Void)?, onError: (()->Void)?){
        networkManager.searchPokemon(
            name: name.lowercased(),
            onSuccess: { pokemon in
                self.isSearching = true
                self.pokemons = nil
                self.pokemonModels = [pokemon]
                self.nextPageURL = nil
                self.nextOffset = nil
                self.cellViewModel = [PokemonListCellViewModel(pokemonModel: pokemon)]
                onSuccess?()
            },
            onError: {
                onError?()
            }
        )
    }
    
}
