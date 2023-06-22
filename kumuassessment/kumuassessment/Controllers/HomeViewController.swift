//
//  ViewController.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/20/23.
//

import UIKit

class HomeViewController: UIViewController {
    /// Instance of HomeViewController. Used when getting the favorite movie list
    static var shared: HomeViewController? = nil
    
    // MARK: - Variables and Constants
    private let homeView = MovieListView()
    private let movieDetailsView = MovieDetailsViewController()
    
    private var movies = [Movie]()
    private var filteredMovies = [Movie]()
    var favoriteList = [SavableData]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        HomeViewController.shared = self
        
        setupTableView()
        requestTableData()
        setupSearchBar()
        setupDetailsView()
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if view.subviews.contains(movieDetailsView.view) {
            movieDetailsView.view.removeFromSuperview()
        }
        
        reloadTable()
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
    }
    
    private func setupDetailsView() {
        addChild(movieDetailsView)
        movieDetailsView.didMove(toParent: self)
    }
    
    private func requestTableData() {
        APIHandler.shared.getMovies{results in
            switch (results) {
            case .success(let movies):
                self.favoriteList = DataPersistenceManager.loadFavorites() ?? [SavableData]()
                self.movies = movies.results
                self.filteredMovies = movies.results
                DispatchQueue.main.async { [weak self] in
                    self?.homeView.movieListTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupSearchBar() {
        homeView.searchBar.delegate = self
        navigationItem.titleView = homeView.searchBar
    }
}

// MARK: - TableView Delegates
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }
        
        if let favoriteIndex = favoriteList.firstIndex(where: { $0.movie.trackId == self.filteredMovies[indexPath.row].trackId }) {
            cell.setup(movie: self.filteredMovies[indexPath.row], isFavorite: self.favoriteList[favoriteIndex].isFavorite)
            return cell
        }
        
        cell.setup(movie: self.filteredMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
        
        if let favoriteIndex = favoriteList.firstIndex(where: { $0.movie.trackId == self.filteredMovies[indexPath.row].trackId }) {
            movieDetailsView.setup(movie: self.filteredMovies[indexPath.row], isFavorite: self.favoriteList[favoriteIndex].isFavorite)
            return
        }
        movieDetailsView.setup(movie: filteredMovies[indexPath.row])
    }
}

// MARK: - SearchBar Delegates
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = movies.filter { movie in
            if (searchBar.text != "") {
                guard let match = (movie.trackName?.lowercased().contains(searchText.lowercased())) else {
                    return false
                }
                return match
            } else {
                return true
            }
        }
        
        homeView.movieListTable.reloadData()
    }
}
