//
//  Enums.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/26.
//

//error에 대한 목록
enum Errors: Error {
    case networkError
    case jsonParsingError
    case dataError
    case etc
}

enum SearchMainType: Int {
    case category
    case discover
}
