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
    
    ///размер загружаемой картинки уменьшить?
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleToFill
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
        titleLabel.font = UIFont(name: "Noto Sans Oriya", size: frame.height/6.5)
        dateAndSourceLabel.font = UIFont(name: "Helvetica", size: frame.height/11)

        setConstraints()
    }
        
    func configure(with viewModel: NewsTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        dateAndSourceLabel.text = "\(convertDateFormat(inputDate: viewModel.publishedAt))"+".   \(viewModel.source)"
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
    }
    
    private func setupView() {
        stackViewForLabels = UIStackView(arrangedSubviews: [titleLabel, dateAndSourceLabel])
        stackViewForLabels.alignment = .leading
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .fillProportionally
        contentView.addSubview(stackViewForLabels)
        contentView.addSubview(newsImageView)
    }
    
    private func convertDateFormat(inputDate: String) -> String {
         let oldDateFormatter = DateFormatter()
         oldDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         guard let oldDate = oldDateFormatter.date(from: inputDate) else { return "" }

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
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackViewForLabels.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackViewForLabels.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -8),
            stackViewForLabels.heightAnchor.constraint(equalTo: heightAnchor, constant: -16),
            stackViewForLabels.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}