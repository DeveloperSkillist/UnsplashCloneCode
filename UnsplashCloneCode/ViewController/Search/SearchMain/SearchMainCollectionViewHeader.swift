//
//  SearchMainCollectionViewHeader.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit

class SearchMainCollectionViewHeader: UICollectionReusableView {
    var headerLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
