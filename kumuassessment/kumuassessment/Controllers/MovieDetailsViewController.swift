//
//  MovieDetailsView.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Variables
    private var movieDetailView = MovieDetailsView()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let bounds = UIScreen.main.bounds
        movieDetailView = MovieDetailsView(frame: bounds)
        view = movieDetailView
    }
    
    // MARK: - Public functions
    /// Sets up the movie details screen
    /// - Parameters:
    ///     - movie: An object of Movie class that contains the details of the movie
    ///     - isFavorite: The toggle on whether the movie is favorited or not
    func setup(movie: Movie, isFavorite: Bool = false) {
        movieDetailView.setup(movieDetails: movie, isFavorite: isFavorite)
    }
}
