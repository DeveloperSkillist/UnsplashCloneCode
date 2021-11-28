//
//  CellChangeDelegate.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import Foundation

protocol CellChangeDelegate: AnyObject {
    func changedCell(row: Int)
}
