//
//  SubCardsViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//
import UIKit

final class SubCardsViewModel {
    
    var list: Observable<[SubCardModelDTO]> = Observable([])
    var editingSubCard: Observable<SubCardModelDTO> = Observable(SubCardModelDTO())
    
}

extension SubCardsViewModel {
    
    func selectCard(id: UUID) -> SubCardModelDTO? {
        let index = list.value.firstIndex { subCard in
            subCard.id == id
        }
        guard let index = index else { return nil }
        
        let card = list.value[index]
        
        return card
    }
    
    func updateSubCard(id: UUID,
                       card: SubCardModelDTO ) {
        let index = list.value.firstIndex { subCard in
            subCard.id == id
        }
        guard let index = index else { return }
        
        list.value[index] = card
        
    }
    
    func deleteSubCard(uuidsToDelete: Set<UUID>) {
        
        list.value = list.value.filter { subCard in
            !uuidsToDelete.contains(subCard.id)
        }
    }
  
}

extension SubCardsViewModel {
    
    func updateEditingCardTitle(title: String?) {
        editingSubCard.value.title = title
    }
    
    func updateEditingCardImages(images: [UIImage]?) {
        editingSubCard.value.images = images
    }
    
    func updateEditingCardStarState(starState: [Bool]) {
        editingSubCard.value.starsState = starState
    }
    
    func updateEditingCardPrice(price: String?) {
        if price?.suffix(1) == "." {
            if price?.suffix(2) != ".." { return }
        }
        
        if let price = price {
            editingSubCard.value.price = (Double(price) != nil) ? Double(price)! : nil
        }
    }
    
    func updateEditingCardLocation(location: LocationDTO?) {
        editingSubCard.value.location = location
        
    }
    
    func updateEditingCardCategory(category: CardCategory) {
        editingSubCard.value.category = category
    }
    
    func updateEditingCardScript(text: String?) {
        editingSubCard.value.script = text
    }
    
}
