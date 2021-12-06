//
//  SearchNavigationViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit

class SearchNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar apeearance 설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

