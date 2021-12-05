//
//  SearchResultCollectionViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/12/04.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchResultCollectionViewController: UIViewController {
    //메인 사진 목록을 보여줄 CollectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.invalidateLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    var currentSearchType: SearchType = .Photos {
        didSet {
            collectionView.setContentOffset(.zero, animated: false)
            fetchFirstSearch()
        }
    }
    
    private var isSearchFetching = false
    private var searchPageNum = 0
    private var searchLastPageNum = 0
    var searchText = ""
    var items: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionView.backgroundColor = .black
        
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        collectionView.register(SearchCollectionCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionCollectionViewCell")
        collectionView.register(SearchUserCollectionViewCell.self, forCellWithReuseIdentifier: "SearchUserCollectionViewCell")
        collectionView.prefetchDataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        view.sizeToFit()
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
    }
}

extension SearchResultCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch currentSearchType {
        case .Photos:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let item = items[indexPath.row] as? Photo else {
                return UICollectionViewCell()
            }
            cell.setup(photo: item)
            return cell
            
        case .Collections:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCollectionViewCell", for: indexPath) as? SearchCollectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let item = items[indexPath.row] as? Collection else {
                return UICollectionViewCell()
            }
            cell.setup(collection: item)
            return cell
            
        case .Users:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchUserCollectionViewCell", for: indexPath) as? SearchUserCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let row = indexPath.row
            guard let item = items[row] as? User else {
                return UICollectionViewCell()
            }
            
            if row == 0 {
                cell.firstIndexSetup(user: item)
            } else if row == items.count-1 {
                cell.lastIndexSetup(user: item)
            } else {
                cell.middleIndexSetup(user: item)
            }
            return cell
        }
    }
}

extension SearchResultCollectionViewController {
    
    func resetResult() {
        items = []
        collectionView.reloadData()
    }
    
    func fetchFirstSearch(searchText: String = "") {
        items.removeAll()
        collectionView.reloadData()
        
        if !searchText.isEmpty {
            self.searchText = searchText
        }
        UnsplashAPI.dataTask?.cancel()
        isSearchFetching = false
        searchPageNum = 0
        searchLastPageNum = 0
        fetchSearch()
    }
    
    func fetchSearch() {
        print("searchPageNum : \(searchPageNum + 1)")
        print("searchLastPageNum : \(searchLastPageNum)")
        if searchPageNum + 1 == searchLastPageNum {
            return
        }
        
        if isSearchFetching {
            return
        }
        isSearchFetching = true
        
        UnsplashAPI.fetchSearchResult(searchText: searchText, searchType: currentSearchType, pageNum: searchPageNum + 1) { [weak self] data, response, error in
            self?.isSearchFetching = false
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      DispatchQueue.main.async {    //에러 발생 시 에러 보여주기
                          self?.showNetworkErrorAlert(error: .networkError)
                      }
                      return
                  }
            
            switch response.statusCode {
            //response 성공 시, 목록 설정하기
            case (200...299):
                do {
                    switch self?.currentSearchType {
                    case .Photos:
                        let result = try JSONDecoder().decode(SearchPhotos.self, from: data)
                        self?.searchLastPageNum = result.totalPages
                        
                        if self?.searchPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                            self?.items = result.results
                        } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                            self?.items.append(contentsOf: result.results)
                        }
                        
                    case .Collections:
                        let result = try JSONDecoder().decode(SearchCollections.self, from: data)
                        self?.searchLastPageNum = result.totalPages
                        
                        if self?.searchPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                            self?.items = result.results
                        } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                            self?.items.append(contentsOf: result.results)
                        }
                        
                    case .Users:
                        let result = try JSONDecoder().decode(SearchUsers.self, from: data)
                        self?.searchLastPageNum = result.totalPages
                        
                        if self?.searchPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                            self?.items = result.results
                        } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                            self?.items.append(contentsOf: result.results)
                        }
                        
                    case .none:
                        return
                    }
                    
                    DispatchQueue.main.async {
                        //다음 페이지 번호 설정
                        self?.searchPageNum += 1
                        self?.collectionView.layoutIfNeeded()
                        self?.collectionView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                        self?.showNetworkErrorAlert(error: .jsonParsingError)
                    }
                }
                
            default:
                DispatchQueue.main.async {  //에러 발생 시 에러 보여주기
                    self?.showNetworkErrorAlert(error: .networkError)
                }
                return
            }
        }
    }
}

extension SearchResultCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentSearchType {
        case .Photos:
            guard let photo = items[indexPath.row] as? Photo else {
                return .zero
            }
            let cellWidth = collectionView.frame.width
            let cellHeight = photo.imageRatio * cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
            
        case .Collections:
            let cellWidth = collectionView.frame.width - 10
            let cellHeight = cellWidth * 0.7
            return CGSize(width: cellWidth, height: cellHeight)
            
        case .Users:
            let cellWidth = collectionView.frame.width - 10
            let cellHeight:CGFloat = 100
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    //여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch currentSearchType {
        case .Photos:
            return UIEdgeInsets(top: 0.5, left: 0, bottom: 0.5, right: 0)
            
        case .Collections:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
        case .Users:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
    }
}

extension SearchResultCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.first else {
            return
        }
        
        let row = indexPath.row
        if row == items.count - 11 ||
            row == items.count - 6 ||
            row == items.count - 1 {
            fetchSearch()
        }
    }
}
