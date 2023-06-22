//
//  NavigationViewController.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import UIKit

class NavigationViewController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        
        homeViewController.tabBarItem.image = UIImage(systemName: "film")
        homeViewController.title = "Home"
        
        favoritesViewController.tabBarItem.image = UIImage(systemName: "star.fill")
        favoritesViewController.title = "Favorites"
        
        setViewControllers([homeViewController, favoritesViewController], animated: true)
    }
}
