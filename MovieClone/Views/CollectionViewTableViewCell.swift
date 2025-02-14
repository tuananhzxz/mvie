//
//  CollectionViewTableViewCell.swift
//  MovieClone
//
//  Created by tuananhdo on 4/1/25.
//

import UIKit

protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell : CollectionViewTableViewCell, viewModel : MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let indentifier = "CollectionViewTableViewCell"
    
    private var movies : [Movie] = [Movie]()
    
    weak var delegate : CollectionViewTableViewCellDelegate?
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal;
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.indentifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movies : [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.indentifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = movies[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let titleName = movie.original_title ?? movie.original_name else {
            return
        }
        
        ApiCaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement) :
                let title = self?.movies[indexPath.row]
                let viewModel = MoviePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title?.overview ?? "")
                guard let strongSelf = self else { return }
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
