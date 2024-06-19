//
//  SelectedLocationInformationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import UIKit
import SnapKit

final class SelectedLocationInformationView: UIView {
    
    private var locationViewModel: SearchLocationViewModel
    private var mainQueue = DispatchQueue.main
    
    weak var delegate: InformationViewDelegate?
    
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let saveButton = UIButton()
    private let openInMapButton = UIButton()
    private let searchButton = UIButton()
    private let noNameButton = UIButton()
    
    
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
}

extension SelectedLocationInformationView {
    
    func updateContent() {
        mainQueue.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = self.locationViewModel.savedLocationMapItem?.name
            self.categoryLabel.text = self.locationViewModel.savedLocationMapItem?.pointOfInterestCategory?.categoryName
        }
        
        
    }
    
    @objc private func saveAction() {
        delegate?.popMapViewController()
    }
    
    @objc private func openInMapAction() {
        locationViewModel.openInMap()
    }
    
    @objc private func searchAction() {
        delegate?.hideInformationView()
    }
    
    @objc private func noNameAction() {
        
    }
    
}

//MARK: - Configuration

extension SelectedLocationInformationView {
    
    private func configureTitle() {
        self.addSubview(titleLabel)
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func configureCategory() {
        self.addSubview(categoryLabel)
        
        categoryLabel.font = .preferredFont(forTextStyle: .body)
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    private func configureSaveButton() {
        self.addSubview(saveButton)
        
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
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(saveButton.snp.width)
        }
    }
    
    private func configureOpenInMapButton() {
        self.addSubview(openInMapButton)
        
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
        
        openInMapButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.leading.equalTo(saveButton.snp.trailing).offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(openInMapButton.snp.width)
        }
    }
    
    private func configureSearchButton() {
        self.addSubview(searchButton)
        
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
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.leading.equalTo(openInMapButton.snp.trailing).offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(searchButton.snp.width)
        }
    }
    
    private func configureNoNameButton() {
        self.addSubview(noNameButton)
        
        noNameButton.layer.cornerRadius = 20
        noNameButton.backgroundColor = .lightGray
        noNameButton.isHidden = true
        
        noNameButton.addTarget(self,
                               action: #selector(noNameAction),
                               for: .touchUpInside)
        
        noNameButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.leading.equalTo(searchButton.snp.trailing).offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(noNameButton.snp.width)
        }
    }
    
    private func buttonConfiguration(title: String) -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        configuration.subtitle = title
        configuration.imagePlacement = .top
        configuration.imagePadding = 8
        
        return configuration
    }
    
}

