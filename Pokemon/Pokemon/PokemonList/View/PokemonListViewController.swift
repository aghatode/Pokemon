//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Aditi Patil on 13/04/2024.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView?
    var timer: Timer?
    var searchController = UISearchController(searchResultsController: nil)
    private var viewModel = PokemonListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CustomFlowLayout()
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.accessibilityIdentifier = "pokemonCollectionView"
        setUpSearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        viewModel.fetchPokemon(offset: 0) {
            self.collectionView?.reloadData()
        } onError: {
            
        }
        
    }
    
    func setUpSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon..."
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        
    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = sender as? IndexPath ,  let item = viewModel.pokemonModels?[indexPath.row] , let destinationViewController = segue.destination as? PokemonDetailsViewController{
                destinationViewController.viewModel = PokemonDetailsViewModel(pokemonModel: item)
            }
        }
    }
}

extension PokemonListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemonModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as! PokemonListViewCell
        let item = viewModel.cellViewModel[indexPath.row]
        cell.configure(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let pokemonModel =  viewModel.pokemonModels, pokemonModel.count > 0, indexPath.row == pokemonModel.count - 1 , !viewModel.isSearching{
            let pokemonCount = viewModel.pokemonModels?.count
            viewModel.fetchPokemon(
                offset: viewModel.nextOffset ?? 0,
                onSuccess: {
                    var paths = [IndexPath]()
                    for i in 0..<((self.viewModel.pokemonModels?.count ?? 0) - (pokemonCount ?? 0)) {
                        paths.append(IndexPath(row: (pokemonCount ?? 0 ) + i, section: 0))
                    }
                    self.collectionView?.performBatchUpdates {
                        self.collectionView?.insertItems(at: paths)
                    }
                },
                onError: {
                    // TODO onError
                }
            )
        }
    }
}

extension PokemonListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isSearching = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            if searchText == "" {
                self.timer?.invalidate()
                self.timer = nil
            } else {
                self.viewModel.searchPokemon(name: searchText) {
                    print("success")
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                } onError: {
                    print("Error while searching")
                }

            }
        })
    }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching = false
        viewModel.pokemonModels = []
        viewModel.cellViewModel = []
        viewModel.fetchPokemon(offset: 0) {
            self.collectionView?.reloadData()
        } onError: {
            print("Error")
        }

        
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let itemWidth = (availableWidth - minimumInteritemSpacing) / 2
        itemSize = CGSize(width: itemWidth, height: itemWidth) // You can adjust the height as per your requirement
    }
}



