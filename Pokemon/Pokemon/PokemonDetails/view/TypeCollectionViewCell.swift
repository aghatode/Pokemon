//
//  TypeCollectionViewCell.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel?
    
    func configure(type:String) {
        self.typeLabel?.text = type
    }
}
