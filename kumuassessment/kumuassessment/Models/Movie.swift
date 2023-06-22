//
//  Movies.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/20/23.
//

import Foundation

struct MoviesResultsResponse: Codable {
    let results: [Movie]
}

class Movie: Codable {
    /// Id of the movie
    let trackId: Int?
    
    /// Name of the movie
    let trackName: String?
    
    /// Genre of the movie
    let primaryGenreName: String?
    
    /// Price of the movie
    let trackPrice: Float?
    
    /// 60x60 poster image of the movie
    let artworkUrl60: String?
    
    /// 100x100 poster image of the movie
    let artworkUrl100: String?
    
    /// Synopsis of the movie
    let longDescription: String?
}
