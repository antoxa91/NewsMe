# NewsMe
<a id="anchor"></a>
___

### Features
___

NewsMe - is a news app that uses API from [newsapi.org ](https://newsapi.org). 

:white_check_mark: You can read popular news in 7 different categories (general, sports, technology, health, science, entertainment, business)

:white_check_mark: You can use searchController when switching location to USA

:white_check_mark: Read posts using the `SFSafariViewController` component

+ UIKit
+ UITableView, UICollectionView
+ Text, images and images compression
+ Animate
+ Auto Layout
+ Localization (EN, RUS)
+ Date Formatter
+ Parsing JSON and Codable

### Screen Recording
___
![start Ru](https://user-images.githubusercontent.com/69522563/191196916-6c4131eb-7d1c-4111-8853-3361b64f638b.gif)
![start us](https://user-images.githubusercontent.com/69522563/191198154-ece38dc7-c6d0-4391-ab4b-501c9e4f10c3.gif)
![search](https://user-images.githubusercontent.com/69522563/191198369-e6f2745e-18b3-4346-a114-dcaa6b613001.gif)


### Installation
___

1. Clone or download the project to your local machine
2. Open the project in Xcode
3. Replace  `newsApiKey`  with your valid newsapi.org key in `Constant.swift`

   ```swift
   struct Constants {
       static let searchURLString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=\(newsApiKey)&q="
       
       static let categoryURLString = "https://newsapi.org/v2/top-headlines?apiKey=\(newsApiKey)&country="
       
   ```
4. Run the simulator

[:arrow_up:](#anchor)
