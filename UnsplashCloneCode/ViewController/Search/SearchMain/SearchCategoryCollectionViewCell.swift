//
//  SearchCategoryCollectionViewCell.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

class SearchCategoryCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: DownloadableImageView = {
        var imageView = DownloadableImageView(frame: .zero)
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func setup(category: Category) {
        [
            imageView,
            label
        ].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.edges.equalTo(imageView).inset(8)
        }
        
        imageView.downloadImage(url: category.coverPhoto.urls.thumb)
        label.text = category.title
    }
}
