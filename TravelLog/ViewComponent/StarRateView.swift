//
//  StarRateView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import SnapKit

protocol StarRateViewDelegate: AnyObject {
    
    func updateViewModelValue(starState: [Bool])
}

final class StarRateView: UIView {
    
    weak var delegate: StarRateViewDelegate?
    
    private lazy var starStackView = UIStackView()
    private lazy var stars = [UIButton]()
    var starState = [Bool](repeating: false, count: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(starStackView)
        
        configureStarImage()
        configureStarStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - configuration

extension StarRateView {
    
    private func configureStarStackView() {
        
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.spacing = 4
        
        starStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureStarImage() {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        
        for i in 0..<5 {
            let button = UIButton()
            
            button.tag = i
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            stars.append(button)
            starStackView.addArrangedSubview(button)
            
            button.snp.makeConstraints { make in
                make.height.equalTo(self.snp.height).inset(8)
                make.width.equalTo(button.snp.height)
            }
            
            button.addTarget(self,
                             action: #selector(tapStar),
                             for: .touchUpInside)
            
            if starState[i] {
                button.setImage(starFillImage, for: .normal)
            } else {
                button.setImage(starEmptyImage, for: .normal)
            }
        }
    }
}

//MARK: - method

extension StarRateView {
    
    @objc private func tapStar(_ sender: UIButton) {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        let end = sender.tag
        let filledCount = starState.filter { $0 == true }.count
        
        if starState[end] == false {
            starState[end] = true
            
        } else if starState[end] && filledCount == end + 1{
            starState[end] = !starState[end]
        }
        
        for i in (end + 1)..<5 {
            starState[i] = false
        }
        
        for i in 0..<end {
            starState[i] = true
        }
        
        for i in 0...4 {
            if starState[i] {
                stars[i].setImage(starFillImage, for: .normal)
            } else {
                stars[i].setImage(starEmptyImage, for: .normal)
            }
        }
        
        delegate?.updateViewModelValue(starState: starState)
    }
    
    func updateButton() {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        for i in 0...4 {
            if starState[i] {
                stars[i].setImage(starFillImage, for: .normal)
            } else {
                stars[i].setImage(starEmptyImage, for: .normal)
            }
        }
    }
}
