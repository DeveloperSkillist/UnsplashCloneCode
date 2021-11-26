//
//  Photos.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.

import UIKit

public struct Photo: Decodable {

    public let identifier: String
    public let height: Int
    public let width: Int
    public let color: String
    public let user: User
    public let urls: URLKind
    public let links: LinkKind
    public let likesCount: Int
    public let sponsorship: Sponsorship?
    
    var imageRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case height
        case width
        case color
        case user
        case urls = "urls"
        case links
        case likesCount = "likes"
        case sponsorship
    }
    
    public struct URLKind: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    public struct LinkKind: Decodable {
        let own: String = "self"
        let html: String
        let download: String
        let downloadLocation: String
        
        enum CodingKeys: String, CodingKey {
            case html, download
            case own = "self"
            case downloadLocation = "download_location"
        }
    }
    
    public struct User: Decodable {
        let name: String
    }
    
    public struct Sponsorship: Decodable {
        let tagline: String
    }
}
