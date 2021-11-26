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
        let photoListViewController = PhotoListViewController()
        photoListViewController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        viewControllers = [photoListViewController]
    }
}
