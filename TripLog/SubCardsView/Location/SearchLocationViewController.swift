//
//  SearchLocationViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/15.
//

import MapKit

final class SearchLocationViewController: UIViewController {

    private let locationViewModel = SearchLocationViewModel()
    private var mapSearchService: MapSearchSevice?
    private let searchBar = UISearchBar()

    private lazy var collectionView = SearchListCollectionView(locationViewModel: locationViewModel)
    private lazy var informationView = SelectedLocationInformationView(locationViewModel: locationViewModel)
    
    init(mapSearchService: MapSearchSevice? = nil) {
        self.mapSearchService = mapSearchService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        mapSearchService = MapSearchSevice(viewModel: locationViewModel)
        bind()
        configureSearchBar()
        configureCollectionView()
        configureInformationView()
       
    }
}

//MARK: - Configuration

extension SearchLocationViewController {
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = mapSearchService
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.9697164893, green: 0.9697164893, blue: 0.9697164893, alpha: 1)
        
        let safeArea = view.safeAreaLayoutGuide
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                           constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                           constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                           constant: -16),
          
        ]

        NSLayoutConstraint.activate(searchBarConstraints)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
      
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func configureInformationView() {
        view.addSubview(informationView)
        
        informationView.translatesAutoresizingMaskIntoConstraints = false
      
        let informationViewConstraints = [
            informationView.topAnchor.constraint(equalTo: view.topAnchor),
            informationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(informationViewConstraints)
        
        informationView.isHidden = true
    }
}

extension SearchLocationViewController {
    
    private func bind() {
        locationViewModel.list.observe { [weak self] locationModels in
            self?.collectionView.saveSnapshot(id: locationModels.map{ $0.id })

        }
    }
    
    func isCollectionViewHidden(value: Bool) {
        collectionView.isHidden = value
        searchBar.isHidden = value
        informationView.isHidden = !value
    }
    
    func configureInformationViewDelegate(delegate: InformationViewDelegate) {
        informationView.delegate = delegate
    }
}

//MARK: - CollectionViewDelegate

extension SearchLocationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        mapSearchService?.didSelectSearch(index: indexPath.row)
        
        //가장 밑으로 내리고 그곳에 확인 버튼 누를 경우 저장하는 방식
        isCollectionViewHidden(value: true)
        guard let dataSource = collectionView.dataSource as?
                UICollectionViewDiffableDataSource<Section, UUID>,
              let id = dataSource.itemIdentifier(for: indexPath) else { return }
    
        informationView.updateContent(id: id)

    }
    
}
