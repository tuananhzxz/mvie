//
//  MoviePreviewViewController.swift
//  MovieClone
//
//  Created by tuananhdo on 5/1/25.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let dowloadButton : UIButton = {
        
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "Tải xuống"
        config.image = UIImage(systemName: "arrow.down.circle.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        button.configuration = config
        
        button.configurationUpdateHandler = { button in
            button.configuration?.baseBackgroundColor = button.isHighlighted ? .systemRed : .white
            button.configuration?.baseForegroundColor = button.isHighlighted ? .white : .black
        }
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(dowloadButton)
        view.addSubview(webView)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dowloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            dowloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    func configure(with movie: MoviePreviewViewModel) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.titleOverview
        guard let url = URL(string : "https://www.youtube.com/embed/\(movie.youtubeView.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }

}
