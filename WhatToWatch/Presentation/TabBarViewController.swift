//
//  TabBarViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 24.09.2023.
//

import UIKit

class TabViewController: UITabBarController {
    private enum TabBarItem: Int {
        case topMovies
        case searchMovies
        case favoritesMovies
        
        var title: String {
            switch self {
            case .topMovies:
                return "Топ"
                
            case .searchMovies:
                return "Поиск"
                
            case .favoritesMovies:
                return "Избранное"
            }
        }
        
        var iconName: String {
            switch self {
            case .topMovies:
                return "star"
                
            case .searchMovies:
                return "magnifyingglass"
                
            case .favoritesMovies:
                return "heart"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.topMovies, .searchMovies, .favoritesMovies]
            self.viewControllers = dataSource.map {
                switch $0 {
                case .topMovies:
                    let firstViewController = TopMoviesViewController()
                    return self.wrappedInNavigationController(with: firstViewController, title: $0.title)

                case .searchMovies:
                    let secondViewController = SearchMoviesViewController()
                    return self.wrappedInNavigationController(with: secondViewController, title: $0.title)
                    
                case .favoritesMovies:
                    let thirdViewController = FavoriteFilmsViewController()
                    return self.wrappedInNavigationController(with: thirdViewController, title: $0.title)
                }
            }

            self.viewControllers?.enumerated().forEach {
                $1.tabBarItem.title = dataSource[$0].title
                $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
                $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
            }
        }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
    }
}
