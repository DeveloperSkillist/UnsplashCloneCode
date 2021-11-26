//
//  String+Extension.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/26.
//

import Foundation

extension String {
    //String 로컬라이즈
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
