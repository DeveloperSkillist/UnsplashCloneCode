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

        //TabBar의 아이템 설정
        
        //photo Tab
        let photoListViewController = PhotoListViewController()
        photoListViewController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        //account Tab
        let accountViewController = UINavigationController(rootViewController: LoginViewController())
        accountViewController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        viewControllers = [photoListViewController, accountViewController]
    }
}
