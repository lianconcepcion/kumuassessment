//
//  DataPersistenceManager.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import Foundation

class DataPersistenceManager {
    static let favoriteKey = "favorites"
    
    /// Save the favorited movies
    /// - Parameters:
    ///     -favorites:  An array of SavableData containing the favorite movies
    static func saveFavorites(_ favorites: [SavableData]) {
        let favoritesData = try! JSONEncoder().encode(favorites)
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(favoritesData, forKey: favoriteKey)
        }
    }
    
    /// Load all the saved favorited movies
    /// - Returns: An Array of SavableData containing the favorite movies
    static func loadFavorites() -> [SavableData]? {
        guard let favoritesData = UserDefaults.standard.data(forKey: favoriteKey) else {
            return nil
        }
        let favorites = try! JSONDecoder().decode([SavableData].self, from: favoritesData)
        return favorites
    }
}
