//
//  CategoriesCollectionViewCell.swift
//  NewsMe
//
//  Created by Антон Стафеев on 31.08.2022.
//

import UIKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoriesCollectionViewCell"
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            categoryNameLabel.textColor = self.isSelected ? .label : .secondaryLabel
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryNameLabel.font = UIFont(name: "Noto Sans Oriya Bold", size: frame.height/2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 10
        addSubview(categoryNameLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            categoryNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
