//
//  File.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import Foundation

class SavableData: Codable {
    /// Details of the movie
    var movie: Movie
    
    /// Movie should be included in the favorite list
    var isFavorite: Bool
    
    init(movie: Movie, isFavorite: Bool) {
        self.movie = movie
        self.isFavorite = isFavorite
    }
}
