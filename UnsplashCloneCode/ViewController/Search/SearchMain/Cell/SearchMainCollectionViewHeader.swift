//
//  SearchMainCollectionViewHeader.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit

class SearchMainCollectionViewHeader: UICollectionReusableView {
    private lazy var headerLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func setTitle(title: String) {
        headerLabel.text = title
    }
}
