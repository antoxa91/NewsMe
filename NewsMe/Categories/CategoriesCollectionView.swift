//
//  CategoriesCollectionView.swift
//  NewsMe
//
//  Created by Антон Стафеев on 31.08.2022.
//

import UIKit

protocol SelectCollectionViewItemProtocol {
    func selectItem(index: IndexPath)
}

final class CategoriesCollectionView: UICollectionView {
    
    private let categoryLayout = UICollectionViewFlowLayout()
     
    var cellDelegate: SelectCollectionViewItemProtocol?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: categoryLayout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        categoryLayout.minimumLineSpacing = 5
        categoryLayout.scrollDirection = .horizontal
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        register(CategoriesCollectionViewCell.self,
                 forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        selectItem(at: [0, 0], animated: true, scrollPosition: [.centeredHorizontally])
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.nameForCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else { return UICollectionViewCell() }
        cell.categoryNameLabel.text = Constants.nameForCategories[indexPath.row].localizedCapitalized.localized()
        cell.layer.shadowColor = UIColor.systemMint.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 20
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        cellDelegate?.selectItem(index: indexPath)
    }
}

extension CategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: frame.height/2, weight: .bold)
        ]
        
        let categoryWidth = Constants.nameForCategories[indexPath.item].localized().size(withAttributes: categoryAttributes).width * 1.2
        
        return CGSize(width: categoryWidth,
                      height: collectionView.frame.height)
    }
}
