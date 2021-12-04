//
//  SearchCollections.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/12/05.
//

import Foundation
struct SearchCollections: Decodable {
    let total : Int
    let totalPages : Int
    let results : [Collection]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct Collection: Decodable {
    let identifier: String
    let title: String
    let description: String?
    let coverPhoto: Photo
    let lock: Bool

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case description
        case coverPhoto = "cover_photo"
        case lock = "private"
    }
}
