//
//  SearchDiscoverCollectionViewCell.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

class SearchDiscoverCollectionViewCell: UICollectionViewCell {
    private var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isCancel = true
    }
    
    func setup(photo: Photo) {
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
            $0.leading.trailing.bottom.equalTo(imageView).inset(5)
        }
        
        imageView.downloadImage(url: photo.urls.regular)
        label.text = photo.user.name
    }
}
