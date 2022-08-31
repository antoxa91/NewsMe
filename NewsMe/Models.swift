//
//  Models.swift
//  NewsMe
//
//  Created by Антон Стафеев on 29.08.2022.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source?
    let title: String
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
