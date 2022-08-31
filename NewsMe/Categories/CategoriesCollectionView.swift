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

class CategoriesCollectionView: UICollectionView {
    
    private let categoryLayout = UICollectionViewFlowLayout()

    let nameRusCategories = ["Главное", "Спорт", "Технологии", "Наука", "Здоровье", "Развлечения", "Бизнес" ]
     
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
        nameRusCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else { return UICollectionViewCell() }
        cell.categoryNameLabel.text = nameRusCategories[indexPath.item]
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
        let categoryFont = UIFont(name: "Helvetica", size: 20)
        let categoryAttributes = [NSAttributedString.Key.font: categoryFont as Any]
        let categoryWidth = nameRusCategories[indexPath.item].size(withAttributes: categoryAttributes).width + 20
        
        return CGSize(width: categoryWidth,
                      height: collectionView.frame.height)
    }
}
