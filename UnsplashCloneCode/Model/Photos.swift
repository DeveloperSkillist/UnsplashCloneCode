//
//  Photos.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.

import Foundation
public struct Photo: Decodable {

    public let identifier: String
    public let height: Int
    public let width: Int
    public let color: String
    public let exif: photoExif?
    public let user: User
    public let urls: URLKind
    public let links: LinkKind
    public let likesCount: Int
    public let sponsorship: Sponsorship?


    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case height
        case width
        case color
        case exif
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
    
    public struct photoExif: Decodable {

        public let aperture: String
        public let exposureTime: String
        public let focalLength: String
        public let iso: String
        public let make: String
        public let model: String

        private enum CodingKeys: String, CodingKey {
            case aperture
            case exposureTime = "exposure_time"
            case focalLength = "focal_length"
            case iso
            case make
            case model
        }
    }
}