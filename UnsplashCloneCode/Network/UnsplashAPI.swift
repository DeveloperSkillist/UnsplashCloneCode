//
//  UnsplashAPI.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import Foundation

class UnsplashAPI {
    //unsplash 기본 URLComponent
    //https://api.unsplash.com/photos?page=1
    static var unsplashURLComponent: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        return urlComponents
    }
    
    //photo 목록 fetch
    //https://unsplash.com/documentation#list-photos
    static func fetchPhotos(pageNum: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var urlComponents = unsplashURLComponent
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageNum)),
            URLQueryItem(name: "per_page", value: "30"),
            //본인의 accesskey를 입력하세요.
            URLQueryItem(name: "client_id", value: APIKeys.accesskey)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    //category 목록 fetch
    //https://api.unsplash.com/topics
    static func fetchCategories(completionHandler: @escaping (Data?, URLResponse?, Error?) ->Void ) {
        var urlComponents = unsplashURLComponent
        urlComponents.path = "/topics"
        urlComponents.queryItems = [
            //본인의 accesskey를 입력하세요.
            URLQueryItem(name: "client_id", value: APIKeys.accesskey)
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
