//
//  MovieTableViewCell.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/20/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Variables and Constants
    static let identifier = "MovieTableViewCell"
    
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
        return labelView
    }()
    
    private let genreLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    private let priceLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    func setup(movie: Movie, isFavorite:Bool = false) {
        self.movie = movie
        movieTitleLabelView.text = movie.trackName
        genreLabelView.text = movie.primaryGenreName
        
        guard let price = movie.trackPrice else {
            return
        }
        priceLabelView.text = String(format: "$ %.02f", price)
        
        guard let url = URL(string: movie.artworkUrl60 ?? "") else {
            posterImageView.image = UIImage(named: "NoImage")
            return
        }
        posterImageView.loadUrl(url)
        self.isFavorite = isFavorite
        setFavoriteButtonImageState()
    }
    
    // MARK: - Private functions
    private func setupSubviews() {
        posterImageView.frame = contentView.bounds
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieTitleLabelView)
        contentView.addSubview(genreLabelView)
        contentView.addSubview(priceLabelView)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(onButtonClick), for: .touchDown)
        setFavoriteButtonImageState()
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
        // Poster Image
        contentView.addConstraint(posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        contentView.addConstraint(posterImageView.widthAnchor.constraint(equalToConstant: 100))
        contentView.addConstraint(posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        contentView.addConstraint(posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5))
        
        // Movie Title Label
        contentView.addConstraint(movieTitleLabelView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor))
        contentView.addConstraint(movieTitleLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50))
        contentView.addConstraint(movieTitleLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        contentView.addConstraint(movieTitleLabelView.heightAnchor.constraint(equalToConstant: 30))
        
        // Genre Label
        contentView.addConstraint(genreLabelView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor))
        contentView.addConstraint(genreLabelView.topAnchor.constraint(equalTo: movieTitleLabelView.bottomAnchor))
        contentView.addConstraint(genreLabelView.heightAnchor.constraint(equalToConstant: 30))
        
        contentView.addConstraint(priceLabelView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor))
        contentView.addConstraint(priceLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5))
        contentView.addConstraint(priceLabelView.heightAnchor.constraint(equalToConstant: 30))
        
        // Favorite Button
        contentView.addConstraint(favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0))
        contentView.addConstraint(favoriteButton.heightAnchor.constraint(equalToConstant: 50))
        contentView.addConstraint(favoriteButton.widthAnchor.constraint(equalToConstant: 50))
        contentView.addConstraint(favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25))
    }
}
