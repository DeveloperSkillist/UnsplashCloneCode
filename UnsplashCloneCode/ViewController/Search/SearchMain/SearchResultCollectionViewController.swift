//
//  SearchResultCollectionViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/12/04.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchResultCollectionViewController: UICollectionViewController {
    var currentSearchType: SearchType = .Photos {
        didSet {
            fetchFirstSearch()
        }
    }
    private var isSearchFetching = false
    private var searchPageNum = 0
    var searchText = ""
    var items: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .yellow
        
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
    }
}

extension SearchResultCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            return UICollectionViewCell()
            
        case .Users:
            return UICollectionViewCell()
        }
    }
}

extension SearchResultCollectionViewController {
    
    func resetResult() {
        items = []
        collectionView.reloadData()
    }
    
    func fetchFirstSearch(searchText: String = "") {
        searchPageNum = 0
        if !searchText.isEmpty {
            self.searchText = searchText
        }
        fetchSearch()
    }
    
    func fetchSearch() {
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
//                    print("data : \(data.description)")
                    let result = try JSONDecoder().decode(SearchPhotos.self, from: data)
                    
                    if self?.searchPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                        self?.items = result.results
                    } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                        self?.items.append(contentsOf: result.results)
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
