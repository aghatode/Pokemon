//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Aditi Patil on 14/04/2024.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var typeCollectionView: UICollectionView?
    @IBOutlet weak var statsTableView: UITableView?
    @IBOutlet weak var heightLabel: UILabel?
    @IBOutlet weak var weightLabel: UILabel?
    @IBOutlet weak var pokemonID: UILabel?
    @IBOutlet weak var pokemonImageView: CustomImageView?
    
    var viewModel: PokemonDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statsTableView?.delegate = self
        statsTableView?.dataSource = self
        typeCollectionView?.delegate = self
        typeCollectionView?.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        self.heightLabel?.text = viewModel?.height
        self.weightLabel?.text = viewModel?.weight
        self.pokemonID?.text =  "#" + String(viewModel?.id ?? 0)
        pokemonImageView?.loadImage(urlString: viewModel?.imageURL ?? "", id: String(viewModel?.id ?? 0))
        let button = UIBarButtonItem()
        button.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = viewModel?.name
        self.navigationItem.largeTitleDisplayMode = .always
    }

   
}


extension PokemonDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.stats.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let stats = viewModel?.stats {
            let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.cellId, for: indexPath) as! StatsTableViewCell
            cell.configure(viewModel: stats[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension PokemonDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.types.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as? TypeCollectionViewCell, let type = viewModel?.types[indexPath.row]
        {
           cell.configure(type:type)
           return cell
       }
       return UICollectionViewCell()
    }
    
   
}
