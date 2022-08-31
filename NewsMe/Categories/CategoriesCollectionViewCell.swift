//
//  CategoriesCollectionViewCell.swift
//  NewsMe
//
//  Created by Антон Стафеев on 31.08.2022.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoriesCollectionViewCell"
    
    let categoryNameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet {
            layer.borderColor = self.isSelected ? UIColor.systemMint.cgColor : .none
            layer.borderWidth = self.isSelected ? 2 : 0
            categoryNameLabel.font = self.isSelected ?
            UIFont(name: "Noto Sans Oriya Bold", size: 20) :
            UIFont(name: "Noto Sans Oriya Light", size: 15)
        }
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
