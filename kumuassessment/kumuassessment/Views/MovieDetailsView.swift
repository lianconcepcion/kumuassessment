//
//  MovieDetailsView.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import UIKit

class MovieDetailsView: UIView {
    // MARK: - Variables
    private var movie: Movie? = nil
    private var isFavorite: Bool = false
    
    // MARK: - Views Declaration
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 2
        return labelView
    }()
    
    private let genreLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.numberOfLines = 1
        return labelView
    }()
    
    private let descriptionLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 0
        return labelView
    }()
    
    private let priceLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.numberOfLines = 1
        return labelView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        applyConstraints()
    }
    
    // MARK: - Public functions
    /// Sets up the movie details screen
    /// - Parameters:
    ///     - movie: An object of Movie class that contains the details of the movie
    ///     - isFavorite: The toggle on whether the movie is favorited or not
    func setup(movieDetails: Movie, isFavorite: Bool) {
        self.backgroundColor = .white
        movie = movieDetails
        self.isFavorite = isFavorite
        movieTitleLabelView.text = movie?.trackName
        genreLabelView.text = movie?.primaryGenreName
        descriptionLabelView.text = movie?.longDescription
        
        guard let price = movie?.trackPrice else {
            return
        }
        priceLabelView.text = String(format: "$ %.02f", price)
        
        guard let url = URL(string: movie?.artworkUrl100 ?? "") else {
            posterImageView.image = UIImage(named: "NoImage")
            return
        }
        
        posterImageView.loadUrl(url)
        
        setFavoriteButtonImageState()
    }
    
    // MARK: - Private functions
    private func setupSubviews() {
        addSubview(posterImageView)
        addSubview(movieTitleLabelView)
        addSubview(genreLabelView)
        addSubview(priceLabelView)
        addSubview(favoriteButton)
        addSubview(descriptionLabelView)
        
        favoriteButton.addTarget(self, action: #selector(onButtonClick), for: .touchDown)
    }
    
    @objc private func onButtonClick(sender: UIButton!) {
        isFavorite.toggle()
        setFavoriteButtonImageState()
        
        guard let movie = self.movie else {
            return
        }
        
        guard let favoriteIndex = HomeViewController.shared?.favoriteList.firstIndex(where: { $0.movie.trackId == movie.trackId }) else {
            let savableData = SavableData(movie: movie, isFavorite: self.isFavorite)
            HomeViewController.shared?.favoriteList.append(savableData)
            setFavoriteButtonImageState()
            
            DataPersistenceManager.saveFavorites(HomeViewController.shared?.favoriteList ?? [SavableData]())
            return
        }
        
        HomeViewController.shared?.favoriteList[favoriteIndex].isFavorite = isFavorite
        DataPersistenceManager.saveFavorites(HomeViewController.shared?.favoriteList ?? [SavableData]())
    }
    
    private func setFavoriteButtonImageState() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    private func applyConstraints() {
        // Movie Poster
        addConstraint(posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 110))
        addConstraint(posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5))
        addConstraint(posterImageView.widthAnchor.constraint(equalToConstant: 150))
        addConstraint(posterImageView.heightAnchor.constraint(equalToConstant: 225))
        
        // Movie Title Label
        addConstraint(movieTitleLabelView.topAnchor.constraint(equalTo: posterImageView.topAnchor))
        addConstraint(movieTitleLabelView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5))
        addConstraint(movieTitleLabelView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor))
        
        // Movie Genre Label
        addConstraint(genreLabelView.topAnchor.constraint(equalTo: movieTitleLabelView.bottomAnchor, constant: 10))
        addConstraint(genreLabelView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5))
        addConstraint(genreLabelView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor))
        
        // Movie Price Label
        addConstraint(priceLabelView.topAnchor.constraint(equalTo: genreLabelView.bottomAnchor, constant: 25))
        addConstraint(priceLabelView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5))
        addConstraint(priceLabelView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 50))
        
        // Favorite Button
        addConstraint(favoriteButton.topAnchor.constraint(equalTo: posterImageView.topAnchor))
        addConstraint(favoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        addConstraint(favoriteButton.heightAnchor.constraint(equalToConstant: 50))
        addConstraint(favoriteButton.widthAnchor.constraint(equalToConstant: 50))
        
        // Description Label
        addConstraint(descriptionLabelView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor))
        addConstraint(descriptionLabelView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5))
        addConstraint(descriptionLabelView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5))
    }
}
