//
//  PhotoDetailCollectionViewCell.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import UIKit

class PhotoDetailCollectionViewCell: UICollectionViewCell {
    
    var photo: Photo?
    
    private lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func setup(photo: Photo) {
        self.photo = photo
        setupLayout()
    }
}

extension PhotoDetailCollectionViewCell {
    private func setupLayout() {
        self.addSubview(imageView)
        
        guard let photo = photo else {
            return
        }
        
        let cellHeight = CGFloat(photo.height) * contentView.frame.width / CGFloat(photo.width)
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(6.5)
            $0.height.equalTo(cellHeight)
        }
        imageView.downloadImage(url: photo.urls.regular)
    }
}
