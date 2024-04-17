//
//  StatsTableViewCell.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    static let cellId = "statsCell"
   
    func configure(viewModel:StatsViewModel) {
        valueLabel.text = String(viewModel.value)
        keyLabel.text = viewModel.name
    }
}
