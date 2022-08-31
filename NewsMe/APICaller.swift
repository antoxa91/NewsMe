//
//  APICaller.swift
//  NewsMe
//
//  Created by Антон Стафеев on 29.08.2022.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    public func getCategoryStories(_ countryName: Country, _ category: NewsCategory, completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = Constants.categoryURLString + countryName.rawValue + "&category=\(category.rawValue)"
        guard let url = URL(string: urlString) else{ return }
        callTask(url: url, completion: completion)
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void){
            guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            let urlString = Constants.searchURLString + query
            
            guard let url = URL(string: urlString) else{
                return
            }
            callTask(url: url, completion: completion)
        }
    
    private func callTask(url: URL, completion: @escaping (Result<[Article], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        task.resume()
    }
    
}
