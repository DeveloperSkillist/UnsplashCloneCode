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
    private var isFail: Bool = false {
        willSet {
            textView.isHidden = !newValue
            loadingView.stopAnimating()
        }
    }
    
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
        super.init(coder: coder)
        
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
//        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(url: String) {
        isCancel = false
        isFail = false
        
        if let image = ImageCache.shared.object(forKey: url as NSString) {
            self.image = image
            return
        }
        
        guard let url = URL(string: url) else {
            self.isFail = true
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
                      self.isFail = true
                      return
                  }
            
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
            
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
