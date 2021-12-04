//
//  SearchUsers.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/12/05.
//


import Foundation
struct SearchUsers: Codable {
    let total : Int
    let totalPages : Int
    let results : [User]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct User: Codable {
    let identifier: String
    let name: String
    let username: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case username
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
