//
//  HomeView.swift
//  kumuassessment
//
//  Created by Lian Concepcion on 6/21/23.
//

import UIKit

class MovieListView: UIView {
    // MARK: - Views Declaration
    let movieListTable = UITableView()
    let searchBar = UISearchBar()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
    }
    
    // MARK: - Private functions
    private func createSubviews() {
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        movieListTable.frame = self.bounds
        addSubview(movieListTable)
    }
    
    private func setupSearchBar() {
        searchBar.sizeToFit()
        addSubview(searchBar)
    }
}
