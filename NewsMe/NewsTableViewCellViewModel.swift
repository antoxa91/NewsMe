//
//  NewsTableViewCellViewModel.swift
//  NewsMe
//
//  Created by Антон Стафеев on 29.08.2022.
//

import Foundation

final class NewsTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data? = nil
    let publishedAt: String
    let source: String
    
    init(title: String, imageURL: URL?, publishedAt: String, source: String) {
        self.title = title
        self.imageURL = imageURL
        self.publishedAt = publishedAt
        self.source = source
    }
}
