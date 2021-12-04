//
//  SearchCollectionCollectionViewCell.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/12/05.
//

import UIKit

class SearchCollectionCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: DownloadableImageView = {
        var imageView = DownloadableImageView(frame: .zero)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isCancel = true
        imageView.image = nil
        label.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
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
    }
    
    func setup(collection: Collection) {
        
        imageView.downloadImage(url: collection.coverPhoto.urls.regular)
        label.text = collection.title
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
