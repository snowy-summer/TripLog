//
//  MainCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

final class MainCardCell: UICollectionViewCell {
    
    static let identifier = "MainCardCell"
    
    private var id: UUID?
    weak var delegate: CellDelegate?
    
    private lazy var titleLabel = UILabel()
    private lazy var thumbnailImageView = UIImageView()
    private lazy var dateLabel = UILabel()
    private lazy var menuButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        configureThumbnailImageView()
        configureTitlLabel()
        configureDateLabel()
        configureMenuButton()
        configureMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainCardCell {
    
    func updateContent(title: String?,
                       image: UIImage?,
                       date: Date,
                       id: UUID) {
        titleLabel.text = title
        self.id = id
        
        if let thumbnailImage = image {
            thumbnailImageView.image = thumbnailImage
        } else {
            thumbnailImageView.image = UIImage(resource: .skyBlue)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd"
        dateLabel.text = formatter.string(from: date)
    }
    
}

//MARK: - Configuration

extension MainCardCell {
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(resource: .baseOfCell)
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: 8),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -8),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: 16),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -16)
        ]
        
        NSLayoutConstraint.activate(contentViewConstraints)
        
    }
    
    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailImageView.contentMode = .scaleAspectFill
        
        let imageViewConstraints = [
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.widthAnchor,
                                                       multiplier: 0.75)
            
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureTitlLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,
                                               constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor,
                                              multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    private func configureDateLabel() {
        contentView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant:  -8)
        ]
        
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    private func configureMenuButton() {
        contentView.addSubview(menuButton)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        let moreButtonConstraints = [
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -16),
            menuButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            menuButton.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                              multiplier: 0.1),
            menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor,
                                               multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(moreButtonConstraints)
    }
    
    private func configureMenu() {
        
        let edit = UIAction(title: "편집",
                            image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.delegate?.editCard(id: id)
        }
        
        let bookMark = UIAction(title: "즐겨찾기",
                                image: UIImage(systemName: "bookmark")) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.delegate?.bookmarkCard(id: id)
            
        }
        
        let delete = UIAction(title: "삭제",
                              image: UIImage(systemName: "trash"),
                              attributes: .destructive) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.delegate?.deleteCard(id: id)
        }
        
        let items = [
            edit,
            bookMark,
            delete
        ]
        
        menuButton.menu = UIMenu(children: items)
        menuButton.showsMenuAsPrimaryAction = true
        
    }
}
