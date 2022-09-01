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
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    private let categoriesCollectionView = CategoriesCollectionView()
    private lazy var searchVC = UISearchController(searchResultsController: nil)
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    private var isRusNews = true
    private var currentCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Новости"
        view.addSubview(tableView)
        view.addSubview(categoriesCollectionView)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        categoriesCollectionView.cellDelegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe"), menu: changeCountry())
        
        fetchCategoryStories(.russia, .general)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    private func changeCountry() -> UIMenu {
        let russia = UIAction(
            title: "Россия",
            image: UIImage(named: "ru")?.withRenderingMode(.alwaysOriginal)) {[weak self] _ in
                APICaller.shared.getCategoryStories(.russia, NewsCategory(rawValue: self!.currentCategory) ?? .general) {[weak self] result in
                    self?.switchResult(result: result)
                }
                self?.navigationItem.searchController = nil
                self?.isRusNews = true
            }
        
        let usa = UIAction(
            title: "USA",
            image: UIImage(named: "us")?.withRenderingMode(.alwaysOriginal)) {[weak self] _ in
                APICaller.shared.getCategoryStories(.usa, NewsCategory(rawValue: self!.currentCategory) ?? .general) {[weak self] result in
                    self?.switchResult(result: result)
                }
                self?.createSearchBar()
                self?.isRusNews = false
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
        let defaultImage = "https://mmuresearchblog.files.wordpress.com/2013/04/news.jpg"
        switch result {
        case .success(let articles):
            self.articles = articles
            self.viewModels = articles.compactMap({
                NewsTableViewCellViewModel(
                    title: $0.title,
                    imageURL: URL(string: $0.urlToImage ?? defaultImage),
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

// MARK: - SelectCollectionViewItemProtocol
extension ViewController: SelectCollectionViewItemProtocol {
    func selectItem(index: IndexPath) {
        currentCategory = Constants.nameForCategories[index.item]
        
        if isRusNews {
            fetchCategoryStories(.russia, NewsCategory(rawValue: currentCategory) ?? .general)
        } else {
            fetchCategoryStories(.usa, NewsCategory(rawValue: currentCategory) ?? .general)
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
        searchVC.searchBar.placeholder = "Поиск в популярном в США"
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

extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            tableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
