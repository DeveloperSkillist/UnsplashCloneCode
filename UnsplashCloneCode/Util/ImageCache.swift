//
//  ImageCache.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import UIKit

//이미지 캐시
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
