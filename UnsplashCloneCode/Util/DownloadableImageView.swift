//
//  DownloadableImageView.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import UIKit
import SnapKit

class DownloadableImageView: UIImageView {
    
    var isCancel: Bool = false
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        loadingView.stopAnimating()
        return loadingView
    }()
    
    private lazy var textView: UILabel = {
        let textView = UILabel()
        textView.text = "이미지를 불러올 수 없습니다."
        textView.font = .systemFont(ofSize: 14, weight: .bold)
        textView.textColor = .white
        textView.textAlignment = .center
        textView.isHidden = true
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("init imageView")
        [
            loadingView,
            textView
        ].forEach {
            self.addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(url: String) {
        isCancel = false
        guard let url = URL(string: url) else {
            self.textView.isHidden = true
            return
        }
        
        loadingView.startAnimating()
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let image = UIImage(data: data) else {
                      print("imageDownload error1")
                      self.textView.isHidden = true
                      return
                  }
            
            if self.isCancel {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                self.loadingView.stopAnimating()
            }
        }
        dataTask.resume()
    }
}
