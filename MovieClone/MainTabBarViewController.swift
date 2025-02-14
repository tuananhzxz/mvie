//
//  ViewController.swift
//  MovieClone
//
//  Created by tuananhdo on 4/1/25.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController());
        let searchVC = UINavigationController(rootViewController: SearchViewController());
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController());
        let dowloadVC = UINavigationController(rootViewController: DowloadViewController());
        
        homeVC.tabBarItem = UITabBarItem(title: "Trang trủ", image: UIImage(systemName: "house.circle"), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "Tìm kiếm", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        upcomingVC.tabBarItem = UITabBarItem(title: "Phim sắp chiếu", image: UIImage(systemName: "calendar"), tag: 2)
        dowloadVC.tabBarItem = UITabBarItem(title: "Tải xuống", image: UIImage(systemName: "arrow.down.circle"), tag: 3)
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, searchVC, upcomingVC, dowloadVC], animated: true)
    }

}

