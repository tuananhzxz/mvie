//
//  HomeViewController.swift
//  MovieClone
//
//  Created by tuananhdo on 4/1/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles : [Movie] = [Movie]()
    
    private let searchController: UISearchController = {
           let controller = UISearchController(searchResultsController: SearchResultsViewController())
           controller.searchBar.placeholder = "Tìm kiếm phim..."
           controller.searchBar.searchBarStyle = .minimal
           return controller
       }()
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        table.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tìm kiếm"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)
        navigationItem.searchController = searchController
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        fetchData()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchData() {
        ApiCaller.shared.getDiscoverMovies { [weak self] (result) in
            switch result {
            case .success(let movies):
                self?.titles = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = titles[indexPath.row]
        cell.configure(with: TitleViewModel(title: movie.original_title ?? "Chưa có thông tin", posterPath: movie.poster_path ?? "", vote_average : movie.vote_average, overview : movie.overview, release_date: movie.release_date))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        ApiCaller.shared.search(with: query) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    resultsController.titles = movies
                    resultsController.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
