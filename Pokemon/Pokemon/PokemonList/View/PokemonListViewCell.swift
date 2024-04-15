//
//  PokemonListViewCell.swift
//  Pokemon
//
//  Created by Aditi Patil on 13/04/2024.
//

import UIKit

class PokemonListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageView: CustomImageView?
    @IBOutlet weak var pokemonNameLabel: UILabel?
    
    func configure(_ model: PokemonListCellViewModel) {
        self.contentView.layer.cornerRadius = 10
        pokemonNameLabel?.text = model.name
        pokemonImageView?.loadImage(urlString: model.imageURL ?? "", id: String(model.id))
    }
    
}


