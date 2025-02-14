//
//  HomeViewController.swift
//  MovieClone
//
//  Created by tuananhdo on 4/1/25.
//

import UIKit

enum Section : Int {
    case Trending = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Movie?
    private var headerView : HeroHeaderUiView?
    
    let sectionTitles : [String] = ["Sôi nổi nhất","Xu hướng", "Đang được chiếu trên tivi", "Sớm được cập nhật", "Được đánh giá cao"]
    
    private let homeFeedTable : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped) //full
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.indentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configurateNavbar()
        
        headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeroHeaderView() {
        ApiCaller.shared.getTrendMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.randomTrendingMovie = movies.randomElement()
                self?.headerView?.configure(with: TitleViewModel(title: self?.randomTrendingMovie?.original_title ?? "Chưa có thông tin", posterPath: self?.randomTrendingMovie?.poster_path ?? "", vote_average: self?.randomTrendingMovie?.vote_average ?? 0, overview: self?.randomTrendingMovie?.overview ?? "", release_date: self?.randomTrendingMovie?.release_date ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configurateNavbar() {
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        logoView.addSubview(imageView)
       
        let logoButton = UIBarButtonItem(customView: logoView)
        logoButton.action = #selector(didTapLogo)
        logoButton.target = self
        navigationItem.leftBarButtonItem = logoButton
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func didTapLogo() {
        print("Logo Tapped")
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.indentifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Section.Trending.rawValue:
            ApiCaller.shared.getTrendMovies { result in
             switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
             }
        case Section.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTv { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
                ApiCaller.shared.getPopularMovies { result in
                    switch result {
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        case Section.Upcoming.rawValue:
                ApiCaller.shared.getUpcomingMovies { result in
                    switch result {
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        case Section.TopRated.rawValue:
            ApiCaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: tableView.bounds.origin.y, width: 100, height: header.bounds.size.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizingFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView : UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController : CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
