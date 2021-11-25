//
//  PhotoListViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/24.
//

import UIKit
import SnapKit

class PhotoListViewController: UIViewController {
    private var pageNum = 0
    private var photos: [Photo] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        fetchPhotos()
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        view.backgroundColor = .systemBackground
//        collectionView.backgroundColor = .yellow
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchPhotos() {
        PhotosAPI.fetchPhotos(pageNum: pageNum + 1) { [weak self] data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      //TODO: error
                      print("fetchPhotos error ")
                      return
                  }
            
            switch response.statusCode {
            case (200...299):
                do {
                    let fetchedPhotos = try JSONDecoder().decode([Photo].self, from: data)
                    self?.photos = fetchedPhotos
                    DispatchQueue.main.async {
                        self?.pageNum += 1
                        self?.collectionView.reloadData()
                    }
                } catch {
                    //TODO: error
                    print("json parsing error \(error.localizedDescription)")
                }
                
            default:
                //TODO: error
                print("network error")
                return
            }
        }
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(photo: photos[indexPath.row])
        //TODO: setup Cell
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoListCollectionViewCell else {
//            return .zero
//        }
//        return CGSize(width: collectionView.frame.width, height: cell.cellHeight)
        let photo = photos[indexPath.row]
        let cellHeight = CGFloat(photo.height) * view.frame.width / CGFloat(photo.width)
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
}
