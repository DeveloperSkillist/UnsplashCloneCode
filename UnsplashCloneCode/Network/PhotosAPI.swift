//
//  PhotoAPI.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import Foundation

class PhotosAPI {
    //https://api.unsplash.com/photos?page=1
    static var photosURLComponent: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos"
        return urlComponents
    }
    
    //https://unsplash.com/documentation#list-photos
    static func fetchPhotos(pageNum: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var urlComponents = photosURLComponent
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageNum)),
            URLQueryItem(name: "client_id", value: APIKeys.accesskey),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
