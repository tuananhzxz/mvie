import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    static let identifier = "MoviesTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(overviewLabel)
        containerView.addSubview(releaseDateLabel)
        containerView.addSubview(ratingView)
        ratingView.addSubview(ratingLabel)
        containerView.addSubview(playButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Poster Image
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            posterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -12),
            
            // Overview Label
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            overviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Rating View
            ratingView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            ratingView.heightAnchor.constraint(equalToConstant: 24),
            ratingView.widthAnchor.constraint(equalToConstant: 45),
            
            // Rating Label
            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            
            // Release Date Label
            releaseDateLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            releaseDateLabel.leadingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: 12),
            
            // Play Button
            playButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            playButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            playButton.heightAnchor.constraint(equalToConstant: 32),
            playButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func translateMonth(_ month: String) -> String {
            let monthTranslations = [
                "Jan": "Tháng 1",
                "Feb": "Tháng 2",
                "Mar": "Tháng 3",
                "Apr": "Tháng 4",
                "May": "Tháng 5",
                "Jun": "Tháng 6",
                "Jul": "Tháng 7",
                "Aug": "Tháng 8",
                "Sep": "Tháng 9",
                "Oct": "Tháng 10",
                "Nov": "Tháng 11",
                "Dec": "Tháng 12"
            ]
            return monthTranslations[month] ?? month
        }
        
        private func formatDate(_ dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else { return dateString }
            
            dateFormatter.dateFormat = "MMM d, yyyy"
            let englishDate = dateFormatter.string(from: date)
            
            // Tách chuỗi ngày tháng
            let components = englishDate.components(separatedBy: " ")
            if components.count == 3 {
                let month = translateMonth(components[0])
                let day = components[1].replacingOccurrences(of: ",", with: "")
                let year = components[2]
                return "Ngày \(day) \(month), \(year)"
            }
            return englishDate
        }
    
    public func configure(with model: TitleViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        ratingLabel.text = String(format: "%.1f", model.vote_average)
        
        if let releaseDate = model.release_date {
            releaseDateLabel.text = formatDate(releaseDate)
        } else {
            releaseDateLabel.text = "Coming Soon"
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
    }
}
