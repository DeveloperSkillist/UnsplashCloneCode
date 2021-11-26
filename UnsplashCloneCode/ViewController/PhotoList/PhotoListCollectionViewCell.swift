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
    
    //다운로드 이미지
    private lazy var photoImageView: DownloadableImageView = {
        let imageView = DownloadableImageView(frame: .zero)
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var photographerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.shadowColor = .black
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 10
        return label
    }()
    
    //cell reuse할 때, 다운로드 중인 이미지 적용 취소하기
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
        photoImageView.downloadImage(url: photo.urls.regular)
    }
}
