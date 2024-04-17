//
//  StatsViewModel.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//

final class StatsViewModel: Equatable {
    let name: String
    let value: Int
    
     init(stats: Stats){
        value = stats.baseStat
        switch stats.stat.name {
        case "hp":
            name = "HP"
        case "attack":
            name = "Attack"
        case "defense":
            name = "Defense"
        case "special-attack":
            name = "Sp. ATK"
        case "special-defense":
            name = "Sp. DEF"
        case "speed":
            name = "Speed"
        default:
            name = ""
        }
    }
    
    static func == (lhs: StatsViewModel, rhs: StatsViewModel) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}
