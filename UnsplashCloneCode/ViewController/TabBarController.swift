//
//  TabBarController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabbarLayout()
        setupTabbarItem()
    }
    
    private func setupTabbarLayout() {
        //tabbar 아이템의 틴트 컬러 변경
        tabBar.tintColor = .white
        
        //tabbar 컬러 변경
        tabBar.barTintColor = .black
    }
    
    private func setupTabbarItem() {
        //TabBar의 아이템 설정
        
        //photo Tab
        let photoListViewController = PhotoListViewController()
        photoListViewController.tabBarItem = UITabBarItem(
            title: "Photo",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        //search Tab
        let searchViewController = SearchNavigationViewController(rootViewController: SearchMainViewController())
        searchViewController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        //account Tab
        let accountViewController = AccountNavigationController(rootViewController: LoginViewController())
        accountViewController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        viewControllers = [photoListViewController, searchViewController, accountViewController]
    }
}
