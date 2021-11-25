//
//  ImageCache.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
