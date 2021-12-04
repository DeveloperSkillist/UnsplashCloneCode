//
//  DownloadableImageView.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/25.
//

import UIKit
import SnapKit

//이미지를 다운로드할 수 있는 이미지뷰
class DownloadableImageView: UIImageView {
    
    var dataTask: URLSessionTask?
    
    //이미지뷰의 다운로드 취소 여부 확인
    var isCancel: Bool = false {
        willSet {
            if newValue {
                dataTask?.cancel()
            }
        }
    }
    
    //이미지 다운로드 실패 시 이미지뷰 처리
    private var isFail: Bool = false {
        willSet {
            DispatchQueue.main.async { [weak self] in
                self?.textView.isHidden = !newValue
                self?.loadingView.stopAnimating()
            }
        }
    }
    
    //이미지 뷰에서 다운로드 중을 보여줄 인디케이터
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        loadingView.stopAnimating()
        return loadingView
    }()
    
    //이미지 뷰에서 다운로드 실패를 알려줄 인디케이터
    private lazy var textView: UILabel = {
        let textView = UILabel()
        textView.text = "image_load_fail".localized
        textView.font = .systemFont(ofSize: 14, weight: .bold)
        textView.textColor = .white
        textView.textAlignment = .center
        textView.isHidden = true
        textView.numberOfLines = 0
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
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
    
    //이미지 Url 입력하여 다운롣,
    func downloadImage(url: String) {
        self.image = nil
        isFail = false
        isCancel = false
        
        //이미지 캐시하여, 이미지가 존재하면, 이미지 적용
        if let image = ImageCache.shared.object(forKey: url as NSString) {
            self.image = image
            return
        }
        
        guard let url = URL(string: url) else {
            self.isFail = true
            return
        }
        
        //이미지 다운로드 시작을 사용자에게 알림
        loadingView.startAnimating()
        
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            if let error = error as NSError?,
               error.code == -999 {
                print("error : dataTask cancel")
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                      self.isFail = true
                      print("imageDownload error : \(error.unsafelyUnwrapped.localizedDescription)")
                      return
                  }
            
            //이미지 캐시
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
            
            //이미지 다운을 취소한경우 중단
            if self.isCancel {
                return
            }
            
            //다운받은 이미지 적용
            DispatchQueue.main.async {
                self.image = image
                self.isFail = false
            }
        }
        dataTask?.resume()
    }
}
