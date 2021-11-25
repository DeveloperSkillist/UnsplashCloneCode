//
//  PhotoListCollectionViewCell.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/24.
//

import UIKit
import SnapKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    var photo: Photo?
    var cellHeight: CGFloat = 0
    
    private lazy var photoImageView: DownloadableImageView = {
        let imageView = DownloadableImageView(frame: .zero)
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private lazy var photographerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.layer.shadowOpacity = 0.1
        return label
    }()
    
    override func prepareForReuse() {
        photoImageView.isCancel = true
    }
    
    func setup(photo: Photo) {
        [
            photoImageView,
            photographerLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photographerLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        photographerLabel.text = photo.user.name
        
        cellHeight = CGFloat(photo.height) * contentView.frame.width / CGFloat(photo.width)
        
        photoImageView.downloadImage(url: photo.urls.regular)
    }
    
}
