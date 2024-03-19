//
//  SelectedLocationInformationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import UIKit

final class SelectedLocationInformationView: UIView {
    
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let saveButton = UIButton()
    private let openInMapButton = UIButton()
    private let searchButton = UIButton()
    private let noNameButton = UIButton()
    
    private var locationViewModel: SearchLocationViewModel
    private var selectedId: UUID?
    
    weak var delegate: InformationViewDelegate?
    
    init (locationViewModel: SearchLocationViewModel ) {
        self.locationViewModel = locationViewModel
        super.init(frame: .zero)
        
        configureTitle()
        configureCategory()
        configureSaveButton()
        configureOpenInMapButton()
        configureSearchButton()
        configureNoNameButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitle() {
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.text = "용산역"
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 16),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
    private func configureCategory() {
        self.addSubview(categoryLabel)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font = .preferredFont(forTextStyle: .body)
        categoryLabel.text = "대중교통"
        
        let categoryLabelConstraints = [
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(categoryLabelConstraints)
    }
    
    private func configureSaveButton() {
        self.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        let configuration = buttonConfiguration(title: "저장")
        
        saveButton.configuration = configuration
        saveButton.layer.cornerRadius = 20
        saveButton.backgroundColor = .lightGray
        saveButton.setImage(UIImage(systemName: "folder.fill.badge.plus"),
                            for: .normal)
        saveButton.clipsToBounds = true
        
        
        saveButton.addTarget(self,
                             action: #selector(saveAction),
                             for: .touchUpInside)
        
        let saveButtonConstraints = [
            saveButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                            constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 16),
            saveButton.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.2),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor,
                                               multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(saveButtonConstraints)
    }
    
    private func configureOpenInMapButton() {
        self.addSubview(openInMapButton)
        
        openInMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        let configuration = buttonConfiguration(title: "지도 앱")
        
        openInMapButton.configuration = configuration
        openInMapButton.layer.cornerRadius = 20
        openInMapButton.backgroundColor = .lightGray
        openInMapButton.setImage(UIImage(systemName: "map.fill"),
                            for: .normal)
        openInMapButton.clipsToBounds = true
        
        openInMapButton.addTarget(self,
                                  action: #selector(openInMapAction),
                                  for: .touchUpInside)
        
        let openInMapButtonConstraints = [
            openInMapButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                            constant: 16),
            openInMapButton.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor,
                                                constant: 16),
            openInMapButton.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.2),
            openInMapButton.heightAnchor.constraint(equalTo: openInMapButton.widthAnchor,
                                               multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(openInMapButtonConstraints)
    }
    
    private func configureSearchButton() {
        self.addSubview(searchButton)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        let configuration = buttonConfiguration(title: "재검색")
        
        searchButton.configuration = configuration
        searchButton.layer.cornerRadius = 20
        searchButton.backgroundColor = .lightGray
        searchButton.setImage(UIImage(systemName: "location.magnifyingglass"),
                            for: .normal)
        searchButton.clipsToBounds = true
        
        
        searchButton.addTarget(self,
                               action: #selector(searchAction),
                               for: .touchUpInside)
        
        let searchButtonConstraints = [
            searchButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                            constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: openInMapButton.trailingAnchor,
                                                constant: 16),
            searchButton.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.2),
            searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor,
                                               multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(searchButtonConstraints)
    }
    
    private func configureNoNameButton() {
        self.addSubview(noNameButton)
        
        noNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        noNameButton.layer.cornerRadius = 20
        noNameButton.backgroundColor = .lightGray
        
        noNameButton.addTarget(self,
                               action: #selector(noNameAction),
                               for: .touchUpInside)
        
        let noNameButtonConstraints = [
            noNameButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                            constant: 16),
            noNameButton.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor,
                                                constant: 16),
            noNameButton.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.2),
            noNameButton.heightAnchor.constraint(equalTo: noNameButton.widthAnchor,
                                               multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(noNameButtonConstraints)
    }
    
    private func buttonConfiguration(title: String) -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        configuration.subtitle = title
        configuration.imagePlacement = .top
        configuration.imagePadding = 8
        
        return configuration
    }
    
    
    func updateContent(id: UUID) {
       
        selectedId = id
        
        let locationModel = locationViewModel.selectedLocation(id: id)
        titleLabel.text = locationModel.searchCompletion?.title
        categoryLabel.text = locationModel.searchCompletion?.subtitle
        
    }
    
    @objc private func saveAction() {
        guard let id = selectedId else { return }
        
        delegate?.backToViewController(location: locationViewModel.selectedLocation(id: id))
    }
    
    @objc private func openInMapAction() {
        guard let id = selectedId else { return }
    
        locationViewModel.openInMap(id: id)
    }
    
    @objc private func searchAction() {
        delegate?.hideInformationView()
    }
    
    @objc private func noNameAction() {
        
    }
    
}

