//
//  Categorys.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/29.
//

import Foundation

// MARK: - Category
struct Category: Decodable {
    let id, slug, title, categoryDescription: String
//    let previewPhotos: [PreviewPhoto]
    let coverPhoto: CoverPhoto

    enum CodingKeys: String, CodingKey {
        case id, slug, title
        case categoryDescription = "description"
//        case previewPhotos = "preview_photos"
        case coverPhoto = "cover_photo"
    }
}

// MARK: - CoverPhoto
struct CoverPhoto: Decodable {
//    let id: String
//    let createdAt, updatedAt: Date
//    let promotedAt: Date?
//    let width, height: Int
//    let color, blurHash: String
//    let coverPhotoDescription, altDescription: String?
    let urls: Urls
//    let links: CoverPhotoLinks
//    let categories: [JSONAny]
//    let likes: Int
//    let likedByUser: Bool
//    let currentUserCollections: [JSONAny]
//    let sponsorship: JSONNull?
//    let topicSubmissions: TopicSubmissions
//    let user: User

    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case promotedAt = "promoted_at"
//        case width, height, color
//        case blurHash = "blur_hash"
//        case coverPhotoDescription = "description"
//        case altDescription = "alt_description"
        case urls
//        case links, categories, likes
//        case likedByUser = "liked_by_user"
//        case currentUserCollections = "current_user_collections"
//        case sponsorship
//        case topicSubmissions = "topic_submissions"
//        case user
    }
}

// MARK: - Urls
struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb: String
}
