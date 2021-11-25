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
//        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        collectionView.refreshControl = refreshController
        return collectionView
    }()
    
    @objc func refreshPhotos() {
        pageNum = 0
        fetchPhotos(isRefresh: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        fetchPhotos()
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        view.backgroundColor = .systemBackground
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchPhotos(isRefresh: Bool = false) {
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
                    if self?.pageNum == 0 {
                        self?.photos = fetchedPhotos
                    } else {
                        self?.photos.append(contentsOf: fetchedPhotos)
                    }
                    DispatchQueue.main.async {
                        if isRefresh {
                            self?.collectionView.refreshControl?.endRefreshing()
                        }
                            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 1, delay: 1, options: .autoreverse, animations: {
//            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//        }) { [weak self] success in
//            //TODO : show detail Page
//            let detailVC = PhotoDetailViewController()
//            detailVC.photos = self?.photos ?? []
//            detailVC.startRow = indexPath.row
//            detailVC.modalPresentationStyle = .overFullScreen
//            self?.present(detailVC, animated: false, completion: nil)
//        }
        
//        UIView.animate(withDuration: 01, animations: {
//            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//        }) { [weak self] success in
//            //TODO : show detail Page
//            let detailVC = PhotoDetailViewController()
//            detailVC.photos = self?.photos ?? []
//            detailVC.startRow = indexPath.row
//            detailVC.modalPresentationStyle = .overFullScreen
//            self?.present(detailVC, animated: false, completion: nil)
//        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
//        collectionView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0,
//            usingSpringWithDamping: 0.7,
//            initialSpringVelocity: 1,
//            options: .curveEaseOut,
//            animations: {
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
//                    return
//                }
//
//                cell.transform = CGAffineTransform(translationX: 0, y: 100)
////                self.view.alpha = 1 - (self.viewPullDownY / (self.view.bounds.height * 0.7))
//            }
//        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let detailVC = PhotoDetailViewController()
            detailVC.photos = self?.photos ?? []
            detailVC.startRow = indexPath.row
            detailVC.modalPresentationStyle = .overFullScreen
            detailVC.cellChangeDelegate = self
            self?.present(detailVC, animated: false, completion: nil)
        }
        
        
    }
}

extension PhotoListViewController: CellChangeDelegate {
    func changedCell(row: Int) {
        collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredVertically, animated: false)
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.row]
        let cellHeight = CGFloat(photo.height) * view.frame.width / CGFloat(photo.width)
        print("row height : \(indexPath.row), \(cellHeight)")
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    
}

extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if photos.count == 0 {
            return
        }
        
        guard let firstIndexPath = indexPaths.first else {
            return
        }
        
        let row = firstIndexPath.row
        if row == photos.count - 11 || row == photos.count - 6 || row == photos.count - 1 {
            print("fetch Next Page \(row)")
            fetchPhotos()
        }
    }
}
