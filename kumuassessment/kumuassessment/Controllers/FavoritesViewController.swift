//
//  FavoritesViewController.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - Variables and Constants
    private let homeView = MovieListView()
    private let movieDetailsView = MovieDetailsViewController()
    
    var favoriteList = [SavableData]()
    var filteredFavoriteList = [SavableData]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if view.subviews.contains(movieDetailsView.view) {
            movieDetailsView.view.removeFromSuperview()
        }
        
        requestTableData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeView.movieListTable.frame = view.bounds
    }
    
    // MARK: - Public functions
    /// Reloads the movie list table
    func reloadTable() {
        homeView.movieListTable.reloadData()
    }
    
    // MARK: - Private Functions
    
    private func setupTableView() {
        homeView.movieListTable.delegate = self
        homeView.movieListTable.dataSource = self
        homeView.movieListTable.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        view.addSubview(homeView.movieListTable)
        
        addChild(movieDetailsView)
        movieDetailsView.didMove(toParent: self)
    }
    
    private func requestTableData() {
        favoriteList = HomeViewController.shared?.favoriteList ?? [SavableData]()
        self.filteredFavoriteList = favoriteList.filter({ favorite in
            favorite.isFavorite
        })
        reloadTable()
    }
    
    private func setupSearchBar() {
        homeView.searchBar.delegate = self
        navigationItem.titleView = homeView.searchBar
    }
}

// MARK: - TableView Delegates
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFavoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.setup(movie: filteredFavoriteList[indexPath.row].movie, isFavorite: filteredFavoriteList[indexPath.row].isFavorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
        movieDetailsView.setup(movie: filteredFavoriteList[indexPath.row].movie, isFavorite: filteredFavoriteList[indexPath.row].isFavorite)
    }
}

// MARK: - SearchBar Delegates
extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFavoriteList = favoriteList.filter { favorite in
            if (searchBar.text != "") {
                guard let match = (favorite.movie.trackName?.lowercased().contains(searchText.lowercased())) else {
                    return false
                }
                return match && favorite.isFavorite
            } else {
                return favorite.isFavorite
            }
        }
        
        homeView.movieListTable.reloadData()
    }
}
