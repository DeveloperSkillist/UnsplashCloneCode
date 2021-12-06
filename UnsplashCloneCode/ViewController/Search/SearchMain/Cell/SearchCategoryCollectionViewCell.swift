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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //label이 잘 보이도록 imageView를 약간 어둡게 만들기 위한 view
    private lazy var dimView: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
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
            dimView,
            label
        ].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.edges.equalTo(imageView).inset(8)
        }
    }
    
    func setup(category: Category) {
        imageView.downloadImage(url: category.coverPhoto.urls.thumb)
        label.text = category.title
        
        //round 설정
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
