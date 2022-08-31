//
//  ViewController.swift
//  NewsMe
//
//  Created by Антон Стафеев on 29.08.2022.
//

import SafariServices
import UIKit

final class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
        
    private lazy var searchVC = UISearchController(searchResultsController: nil)

    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Популярное"
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe"), menu: changeCountry())

        fetchCategoryStories(.russia, .top)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func changeCountry() -> UIMenu {
        let russia = UIAction(
           title: "Россия",
           image: UIImage(named: "ru")?.withRenderingMode(.alwaysOriginal)) {[weak self] _ in
               APICaller.shared.getCategoryStories(.russia, .top) {[weak self] result in
                   self?.switchResult(result: result)
               }
               self?.navigationItem.searchController = nil
               self?.title = "Популярное"
           }
        
        let usa = UIAction(
           title: "USA",
           image: UIImage(named: "us")?.withRenderingMode(.alwaysOriginal)) {[weak self] _ in
               APICaller.shared.getCategoryStories(.usa, .top) {[weak self] result in
                   self?.switchResult(result: result)
               }
               self?.title = "Top"
               self?.createSearchBar()
           }
        
        let menu = UIMenu(title: "Выбери страну для новостей", image: nil, children: [russia, usa])
        return menu
   }

    private func fetchCategoryStories(_ countryName: Country, _ category: NewsCategory) {
        APICaller.shared.getCategoryStories(countryName, category) {[weak self] result in
            self?.switchResult(result: result)
        }
    }
    
    private func switchResult(result: Result<[Article], Error>) {
        switch result {
        case .success(let articles):
            self.articles = articles
            self.viewModels = articles.compactMap({
                NewsTableViewCellViewModel(
                    title: $0.title,
                    imageURL: URL(string: $0.urlToImage ?? ""),
                    publishedAt: $0.publishedAt,
                    source: $0.source?.name ?? ""
                )
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchVC.dismiss(animated: true, completion: nil)
            }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 7
    }
}


// MARK: - Search
extension ViewController: UISearchBarDelegate {
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        searchVC.searchBar.placeholder = "Search in Top Categories in USA"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        
        APICaller.shared.search(with: text) { [weak self] result in
            self?.switchResult(result: result)
        }
    }
}
