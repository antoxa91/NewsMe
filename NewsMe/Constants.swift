//
//  Constants.swift
//  NewsMe
//
//  Created by Антон Стафеев on 30.08.2022.
//

import Foundation

struct Constants {
    static let searchURLString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=\(newsApiKey)&q="
   
    static let categoryURLString = "https://newsapi.org/v2/top-headlines?apiKey=\(newsApiKey)&country="
}

enum Country: String {
    case russia = "ru"
    case usa    = "us"
}

enum NewsCategory: String {
    case business =      "business"
    case entertainment = "entertainment"
    case general =       "general"
    case health =        "health"
    case science =       "science"
    case sports =        "sports"
    case technology =    "technology"
    case top = ""
}
