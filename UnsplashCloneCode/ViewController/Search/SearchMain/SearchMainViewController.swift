//
//  SearchMainViewController.swift
//  UnsplashCloneCode
//
//  Created by skillist on 2021/11/28.
//

import UIKit

class SearchMainViewController: UICollectionViewController {
    var contents: [SearchPhoto] = [SearchPhoto(type: 1), SearchPhoto(type: 1)]
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search photos, collections, users"
        return searchBar
    }()
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] row, _ -> NSCollectionLayoutSection? in
            print("type: \(self?.contents[row].type)")
            switch self?.contents[row].type {
            case 1:
                return self?.createCategorySection()
                
            default:
                return nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupLayout()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            collectionView
        ].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        
        //Header 추가
        collectionView.register(
            SearchMainCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "SearchMainCollectionViewHeader"
        )
        
        //cell 추가
        collectionView.register(SearchCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCategoryCollectionViewCell")
        collectionView.register(SearchDiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "SearchDiscoverCollectionViewCell")
        collectionView.collectionViewLayout = collectionViewLayout
    }
}

extension SearchMainViewController {
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        //아이템
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        //섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Header Header size
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        //section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
}

extension SearchMainViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sectionType = contents[section].type
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.row].type {
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCategoryCollectionViewCell", for: indexPath) as? SearchCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDiscoverCollectionViewCell", for: indexPath) as? SearchDiscoverCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchMainCollectionViewHeader", for: indexPath) as? SearchMainCollectionViewHeader else {
                return UICollectionReusableView()
            }
            
            headerView.headerLabel.text = "temp"
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}
