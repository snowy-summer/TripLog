//
//  MainViewModelProtocol.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import UIKit

protocol MainViewModelProtocol {
    
    var list: Observable<[MainCardDTO]> { get }
    var mainDataManager: MainDataManager { get }
    
    func appendMainCard(title: String, image: UIImage?)
    func changeSubCards(id: UUID, cards: [SubCardModelDTO])
    func deleteCard(id: UUID)
    func bookmarkCard(id: UUID)
    func editMainCardTitle(id: UUID, title: String)
    func editMainCardImage(id: UUID, image: UIImage?)
    func editMainCardDate(id: UUID, date: Date)
    
}
