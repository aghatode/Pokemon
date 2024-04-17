//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Aditi Patil on 13/04/2024.
//

import XCTest
@testable import Pokemon

final class PokemonTests: XCTestCase {
    static let pokemonModel = PokemonModel(
        id: 1,
        name: "bulbasaur",
        height: 7,
        weight: 69,
        sprites: Sprites(
            backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
            backFemale: nil,
            backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
            backShinyFemale: nil,
            frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            frontFemale: nil,
            frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png",
            frontShinyFemale: nil,
            other: Other(
                dreamWorld: DreamWorld(
                    frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg",
                    frontFemale: nil
                ),
                officialArtwork: OfficialArtwork(
                    frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                )
            )
        ),
        stats: [
            Stats(
                baseStat: 45,
                effort: 0,
                stat: Stat(
                    name: "hp",
                    url: "https://pokeapi.co/api/v2/stat/1/"
                )
            ),
            Stats(
                baseStat: 49,
                effort: 0,
                stat: Stat(
                    name: "attack",
                    url: "https://pokeapi.co/api/v2/stat/2/"
                )
            ),
            Stats(
                baseStat: 49,
                effort: 0,
                stat: Stat(
                    name: "defense",
                    url: "https://pokeapi.co/api/v2/stat/3/"
                )
            ),
            Stats(
                baseStat: 65,
                effort: 0,
                stat: Stat(
                    name: "special-attack",
                    url: "https://pokeapi.co/api/v2/stat/4/"
                )
            ),
            Stats(
                baseStat: 65,
                effort: 0,
                stat: Stat(
                    name: "special-defense",
                    url: "https://pokeapi.co/api/v2/stat/5/"
                )
            ),
            Stats(
                baseStat: 45,
                effort: 0,
                stat: Stat(
                    name: "speed",
                    url: "https://pokeapi.co/api/v2/stat/6/"
                )
            )
        ],
        types: [
            TypeElement(
                slot: 1,
                type: Type(
                    name: "grass",
                    url: "https://pokeapi.co/api/v2/type/12/"
                )
            ),
            TypeElement(
                slot: 2,
                type: Type(
                    name: "poison",
                    url: "https://pokeapi.co/api/v2/type/4/"
                )
            )
        ]
    )
    
    func testgetPokemons(){
        let viewModel = PokemonListViewModel()
        viewModel.getPokemons(offset: 0, onSuccess: {_,_ in 
            XCTAssertEqual(viewModel.nextOffset, 20)
            XCTAssertEqual(viewModel.nextPageURL, URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"))
            XCTAssertEqual(viewModel.pokemonModels as! [PokemonListCellViewModel], [PokemonListCellViewModel(pokemonModel: PokemonTests.pokemonModel)])
        }, onError: {
            
        }) 
    }
    
    func testfetchPokemons() {
        let viewModel = PokemonListViewModel()
        viewModel.getPokemons(offset: 0, onSuccess: {_,_ in
            XCTAssertEqual(viewModel.nextOffset, 20)
            XCTAssertEqual(viewModel.nextPageURL, URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"))
            XCTAssertEqual(viewModel.pokemons?.results?.count, 20)
            XCTAssertEqual(viewModel.pokemons?.results?[0], ResultModel(name:"bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
        }, onError: {
        })
    }
    

    func testPokemonListCellViewModel() {
        let pokemonViewModel = PokemonListCellViewModel(pokemonModel: PokemonTests.pokemonModel)
        XCTAssertEqual(pokemonViewModel.id, 1)
        XCTAssertEqual(pokemonViewModel.name, "Bulbasaur")
        XCTAssertEqual(pokemonViewModel.type, "grass")
        XCTAssertEqual(pokemonViewModel.imageURL,  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
    }
    
    func testPokemonDetailsViewModel(){
        let detailViewModel = PokemonDetailsViewModel(pokemonModel: PokemonTests.pokemonModel)
        
        XCTAssertEqual(detailViewModel.id, 1)
        XCTAssertEqual(detailViewModel.namedId, "#001")
        XCTAssertEqual(detailViewModel.name, "Bulbasaur")
        XCTAssertEqual(detailViewModel.type, "grass")
        XCTAssertEqual(detailViewModel.imageURL, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        XCTAssertEqual(detailViewModel.weight, "6.9 Kg")
        XCTAssertEqual(detailViewModel.height, "0.7 m")
        XCTAssertEqual(
            detailViewModel.stats[0],StatsViewModel(
                stats: Stats(
                    baseStat: 45,
                    effort: 0,
                    stat: Stat(
                        name: "hp",
                        url: "https://pokeapi.co/api/v2/stat/1/"
                    )
                )
            ))
    }
    
    func testStatsViewModelDEF(){
        let statsViewModel = StatsViewModel(stats: Stats(baseStat: 49, effort: 0, stat: Stat(name: "defense", url: "https://pokeapi.co/api/v2/stat/3/")))
        
        XCTAssertEqual(statsViewModel.name, "Defense")
        XCTAssertEqual(statsViewModel.value, 49)
    }
    
}
