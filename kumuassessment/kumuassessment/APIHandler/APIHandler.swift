//
//  APIHandler.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/20/23.
//

import Foundation

class APIHandler {
    static let shared = APIHandler()
    
    ///  Fetches list of movies from iTunes
    func getMovies(completion: @escaping (Result<MoviesResultsResponse, Error>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie&amp;all") else { return }
        
        let urlSession = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(MoviesResultsResponse.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        urlSession.resume()
    }
}
