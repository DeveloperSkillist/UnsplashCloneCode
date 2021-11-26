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
    
    //메인 사진 목록을 보여줄 CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.invalidateLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
    
        //스크롤 다운하여 목록 리프레시 구현
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        collectionView.refreshControl = refreshController
        return collectionView
    }()
    
    //스크롤 다운하여 목록 리프레시 시도 시 수행할 동작
    @objc func refreshPhotos() {
        pageNum = 0
        fetchPhotos(isRefresh: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        fetchPhotos()
    }
    
    //레이아웃 구현
    private func setupLayout() {
        view.addSubview(collectionView)
        
        view.backgroundColor = .systemBackground
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //이미지 fetch 구현
    private func fetchPhotos(isRefresh: Bool = false) {
        //현재 페이지에 1을 더하여 다음 페이지 가져오기
        PhotosAPI.fetchPhotos(pageNum: pageNum + 1) { [weak self] data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      DispatchQueue.main.async {    //에러 발생 시 에러 보여주기
                          self?.showErrorAlert(error: .networkError)
                      }
                      return
                  }
            
            switch response.statusCode {
            //response 성공 시, 목록 설정하기
            case (200...299):
                do {
                    let fetchedPhotos = try JSONDecoder().decode([Photo].self, from: data)
                    
                    
                    if self?.pageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                        self?.photos = fetchedPhotos
                    } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                        self?.photos.append(contentsOf: fetchedPhotos)
                    }
                    
                    DispatchQueue.main.async {
                        //리프레시 한 경우 refreshControl 종료
                        if isRefresh {
                            self?.collectionView.refreshControl?.endRefreshing()
                        }
                        
                        //다음 페이지 번호 설정
                        self?.pageNum += 1
                        self?.collectionView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                        self?.showErrorAlert(error: .jsonParsingError)
                    }
                }
                
            default:
                DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                    self?.showErrorAlert(error: .networkError)
                }
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
        //cell 설정
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(photo: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //cell 선택 시 중앙으로 이동 후 detailView 보여주기
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let detailVC = PhotoDetailViewController()
            detailVC.photos = self?.photos ?? []
            detailVC.startRow = indexPath.row
            detailVC.modalPresentationStyle = .overFullScreen   //pullDown하여 VC 종료를 구현하기 위해 overFullScreen 구현
            detailVC.cellChangeDelegate = self  //PhotoDetailViewController에서 사진 변경 시, 목록 위치를 변경하기 위하여 Delegate 구현
            self?.present(detailVC, animated: false, completion: nil)
        }
    }
}

extension PhotoListViewController: CellChangeDelegate {
    func changedCell(row: Int) {    //PhotoDetailViewController에서 사진 변경 시, 메인 목록의 위치를 변경
        collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredVertically, animated: false)
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    //collectionView의 item 사이즈 구현
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.row]
        let cellHeight = CGFloat(photo.height) * view.frame.width / CGFloat(photo.width)
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    //여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.5, left: 0, bottom: 0.5, right: 0)
    }
}

extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    //스크롤 시 마지막 사진이 보여지기 전에 다음 페이지 미리 로딩하기
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if photos.count == 0 {
            return
        }
        
        guard let firstIndexPath = indexPaths.first else {
            return
        }
        
        let row = firstIndexPath.row
        if row == photos.count - 11 || row == photos.count - 6 || row == photos.count - 1 {
            fetchPhotos()
        }
    }
}
