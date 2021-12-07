//
//  SearchUserCollectionViewCell.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/12/05.
//

import UIKit

class SearchUserCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: DownloadableImageView = {
        var imageView = DownloadableImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        [
            titleLabel,
            subLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
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
    
    private func setupLayout() {
        [
            imageView,
            stackView
        ].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(15)
            $0.width.equalTo(imageView.snp.height)
        }
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalTo(imageView)
        }
        
        self.backgroundColor = .darkGray
        self.clipsToBounds = true
    }
    
    func onlySingleIndexSetup(user: User) {
        setup(user: user)
        
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    func firstIndexSetup(user: User) {
        setup(user: user)
        
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    func middleIndexSetup(user: User) {
        setup(user: user)
        
        self.layer.cornerRadius = 0
    }
    
    func lastIndexSetup(user: User) {
        setup(user: user)
        
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    private func setup(user: User) {
        imageView.downloadImage(url: user.profileImage.medium)
        titleLabel.text = user.name
        subLabel.text = user.username
    }
}
