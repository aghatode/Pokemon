//
//  NetworkManager.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//

import Foundation

class NetworkManager {
        
    //Gets list of Pokemons
    func getPokemons(offset: Int = 0, onSuccess: ((_ mainModel: PokemonListModel)->Void)? = nil, onError: (()->Void)? = nil){
        PokemonAPI.get(
            path: "/pokemon",
            params: ["offset": String(offset)],
            onSuccess: { data in
                do {
                    let decoder = JSONDecoder.init()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let mainModel = try decoder.decode(PokemonListModel.self, from: data)
                    onSuccess?(mainModel)
                } catch {
                    print("error pokemons decode")
                    onError?()
                }
            },
            onError: {
                onError?()
            }
        )
    }
    
    //Gets pokemon details for a specific pokemon
    func searchPokemon(name: String, onSuccess: ((_ pokemonModel: PokemonModel)->Void)? = nil, onError: (()->Void)? = nil){
        PokemonAPI.get(path: "/pokemon/\(name)") { data in
            do {
                let decoder = JSONDecoder.init()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                onSuccess?(try decoder.decode(PokemonModel.self, from: data))
            } catch {
                print("error \(name): \(error)")
                onError?()
            }
        } onError: {
            print("error \(name)")
            onError?()
        }
    }
    
}
