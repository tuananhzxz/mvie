//
//  HeroHeaderUiView.swift
//  MovieClone
//
//  Created by tuananhdo on 5/1/25.
//

import UIKit

class HeroHeaderUiView: UIView {
    
    private let leftBorder: UIView = {
           let view = UIView()
           view.backgroundColor = .black
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
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
    
    private let playButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "Xem"
        config.image = UIImage(systemName: "play.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        // Áp dụng configuration
        button.configuration = config
        
        // Thêm trạng thái highlighted khi nhấn
        button.configurationUpdateHandler = { button in
            button.configuration?.baseBackgroundColor = button.isHighlighted ? .systemRed : .white
            button.configuration?.baseForegroundColor = button.isHighlighted ? .white : .black
        }
        
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let imageView : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "spider")
        return image
    }()
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradient()
        addSubview(playButton)
        addSubview(dowloadButton)
        addSubview(leftBorder)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let playButtonConstrants = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let borderConstraints = [
          leftBorder.leadingAnchor.constraint(equalTo: dowloadButton.leadingAnchor, constant: 2), // Điều chỉnh khoảng cách
          leftBorder.centerYAnchor.constraint(equalTo: dowloadButton.centerYAnchor),
          leftBorder.widthAnchor.constraint(equalToConstant: 1), // Độ dày của border
          leftBorder.heightAnchor.constraint(equalToConstant: 20) // Chiều cao của border
        ]
        
        let dowloadButtonConstraints = [
            dowloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            dowloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(playButtonConstrants)
        NSLayoutConstraint.activate(borderConstraints)
        NSLayoutConstraint.activate(dowloadButtonConstraints)
        
    }
    
    public func configure(with model : TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)") else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
