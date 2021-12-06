//
//  SearchMainViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit
import SnapKit

class SearchMainViewController: UIViewController {
    private var contents: [SearchMainItem] = [
        SearchMainItem(type: .category, items: []),
        SearchMainItem(type: .discover, items: [])
    ]
    //Discover 페이징을 위한 저장 프로퍼티
    private var discoverPageNum = 0
    private var isFetching = false
    
    //scopeBar show 관련 프로퍼티
    private lazy var isShowScopeBar = false {
        willSet {
            searchController.searchBar.showsScopeBar = newValue
        }
    }
    
    //검색 결과 표시를 위한 VC
    private lazy var searchResultVC: SearchResultViewController = {
        return SearchResultViewController()
    }()
    
    //searchController
    private lazy var searchController: UISearchController = {
        //searchController 설정
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        //searchBar 설정
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos, collections, users"
        searchController.searchBar.tintColor = .white
        //SearchBar 입력 Text Color 변경
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //ScopeBar Button 설정
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.scopeButtonTitles = ["Photos", "Collections", "Users"]
        
        //scopebar 버튼 color 변경
        let selectedTitleTextColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(selectedTitleTextColor, for: .selected)
        
        let normalTitleTextColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(normalTitleTextColor, for: .normal)
        return searchController
    }()
    
    //collectionView 설정
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Header 추가
        collectionView.register(
            SearchMainCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "SearchMainCollectionViewHeader"
        )
        
        //cell 추가
        collectionView.register(SearchCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCategoryCollectionViewCell")
        collectionView.register(SearchDiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "SearchDiscoverCollectionViewCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupLayout()
        fetchCategories()
        fetchDiscover()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationItem.searchController = searchController
        navigationItem.titleView = searchController.searchBar
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchMainViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch self?.contents[section].type {
            case .category:
                return self?.createCategorySection()
                
            case .discover:
                return self?.createDiscoverSection()
                
            default:
                return nil
            }
        }
    }
    
    //category section
    private func createCategorySection() -> NSCollectionLayoutSection {
        //아이템
        let itemMargin: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = .init(top: 0, leading: itemMargin, bottom: 0, trailing: itemMargin)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
//        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let sectionHeader = createDiscoverSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    //discover section
    //TODO: discover section을 waterfull 방식으로 변경 필요
    private func createDiscoverSection() -> NSCollectionLayoutSection {
        //아이템
        let itemMargin: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
//        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let sectionHeader = createDiscoverSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createDiscoverSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Header Header size
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        //section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}

extension SearchMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents[section].items.count
    }
    
    //cell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch contents[indexPath.section].type {
        case .category:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCategoryCollectionViewCell", for: indexPath) as? SearchCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let categories = contents[indexPath.section].items as? [Category] else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.row]
            cell.setup(category: category)
            return cell
            
        case .discover:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDiscoverCollectionViewCell", for: indexPath) as? SearchDiscoverCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let photos = contents[indexPath.section].items as? [Photo] else {
                return UICollectionViewCell()
            }
            let photo = photos[indexPath.row]
            cell.setup(photo: photo)
            return cell
        }
    }
    
    //header 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchMainCollectionViewHeader", for: indexPath) as? SearchMainCollectionViewHeader else {
                return UICollectionReusableView()
            }
            
            switch contents[indexPath.section].type {
            case .category:
                headerView.setTitle(title: "Browse by Category")
                
            case .discover:
                headerView.setTitle(title: "Discover")
            }
            return headerView
        }
        return UICollectionReusableView()
    }

    //willDisplay로 prefetch 적용
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section != 1 {
            return
        }

        let row = indexPath.row
        if row == contents[1].items.count - 11 ||
            row == contents[1].items.count - 6 ||
            row == contents[1].items.count - 1 {
            fetchDiscover()
        }
    }
}

//MARK: fetch
extension SearchMainViewController {
    
    //fetch catrgories
    private func fetchCategories() {
        UnsplashAPI.fetchCategories { [weak self] data, response, error in
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
                    let fetchedCategories = try JSONDecoder().decode([Category].self, from: data)
                    self?.contents[0].items = fetchedCategories
                    
                    DispatchQueue.main.async {
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
    
    //fetch discover
    private func fetchDiscover() {
        if isFetching {
            return
        }
        isFetching = true
        
        UnsplashAPI.fetchPhotos(pageNum: discoverPageNum + 1) { [weak self] data, response, error in
            self?.isFetching = false
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
                    let fetchedPhotos = try JSONDecoder().decode([Photo].self, from: data)
                    
                    if self?.discoverPageNum == 0 { //첫페이지를 가져온 경우 목록 설정
                        self?.contents[1].items = fetchedPhotos
                    } else { //첫페이지 외 다음페이지를 가져온 경우 목록 설정
                        self?.contents[1].items.append(contentsOf: fetchedPhotos)
                    }
                    
                    DispatchQueue.main.async {
                        //다음 페이지 번호 설정
                        self?.discoverPageNum += 1
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

//MARK: UISearchBarDelegate
extension SearchMainViewController: UISearchBarDelegate {
    
    //searchBar 수정 시작 시 cancelButton show
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //search 버튼 터치 시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text, !searchBarText.isEmpty {
            isShowScopeBar = true
            
            view.endEditing(true)
            //search
            searchResultVC.fetchFirstSearch(searchText: searchBarText)
        }
    }
    
    //cancel 버튼 터치 시
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        isShowScopeBar = false
        
        searchResultVC.resetResult()
    }
    
    //선택한 ScopeButton이 변경되면, 검색 수행
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        var selectType: SearchType = .Photos
        switch selectedScope {
        case 1:
            selectType = .Collections
        case 2:
            selectType = .Users
        default:
            selectType = .Photos
        }
        
        //search
        searchResultVC.currentSearchType = selectType
    }
}
