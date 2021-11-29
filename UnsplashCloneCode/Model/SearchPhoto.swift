//
//  SearchPhoto.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import Foundation

struct SearchPhoto: Decodable {
    let type: Int
}

struct SearchMainItem {
    let type: SearchMainType
    let items: [Any]
}
