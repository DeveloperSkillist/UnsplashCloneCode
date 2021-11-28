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
        
        let cellHeight = photo.imageRatio * contentView.frame.width
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            //BUG: PhotoListViewController와 PhotoDetailViewController의 사진 vertical center가 일치하지 않아, offset 설정
            $0.centerY.equalToSuperview().offset(-18)
            $0.height.equalTo(cellHeight)
        }
        imageView.downloadImage(url: photo.urls.regular)
    }
}
