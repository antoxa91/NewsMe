//
//  NewsTableViewCell.swift
//  NewsMe
//
//  Created by Антон Стафеев on 29.08.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateAndSourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.highlightedTextColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stackViewForLabels = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        newsImageView.image = nil
        dateAndSourceLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.font = UIFont(name: "Noto Sans Oriya", size: frame.height/7.1)
        dateAndSourceLabel.font = UIFont(name: "Helvetica", size: frame.height/11)
        
        setConstraints()
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        dateAndSourceLabel.text = "\(convertDateFormat(inputDate: viewModel.publishedAt))"+".   \(viewModel.source)"
        
        if let data = viewModel.imageData {
            newsImageView.image = compressImage(image: ((UIImage(data: data) ?? UIImage(named: "newsPicDefault"))!))
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                
                let image = self?.compressImage(image: (UIImage(data: data) ?? UIImage(named: "newsPicDefault"))!)
                
                DispatchQueue.main.async { [weak self] in
                    UIView.transition(
                        with: self?.newsImageView ?? UIImageView(),
                        duration: 0.9,
                        options: [.curveEaseOut, .transitionCrossDissolve],
                        animations: {
                            self?.newsImageView.image = image
                        })
                }
            }.resume()
        }
    }
    
    private func setupView() {
        stackViewForLabels = UIStackView(arrangedSubviews: [titleLabel, dateAndSourceLabel])
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .equalCentering
        contentView.addSubview(stackViewForLabels)
        contentView.addSubview(newsImageView)
    }
    
    private func compressImage(image: UIImage) -> UIImage {
        let resizedImage = image.aspectFittedToHeight(100)
        resizedImage.jpegData(compressionQuality: 0.5)
        return resizedImage
    }
        
    private func convertDateFormat(inputDate: String) -> String {
        let oldDateFormatter = DateFormatter()
        oldDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let oldDate = oldDateFormatter.date(from: inputDate) else {
            return ""
        }
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateStyle = .short
        convertDateFormatter.timeStyle = .short
        return convertDateFormatter.string(from: oldDate)
    }
}


// MARK: - Constraints
extension NewsTableViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            newsImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackViewForLabels.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            stackViewForLabels.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackViewForLabels.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 8),
            stackViewForLabels.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
