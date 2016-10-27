//
//  FlashCardPlayModel.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/20.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import RealmSwift

protocol FlashCardPlayModelDelegate {
    func renderCardsText()
}

class FlashCardPlayModel {
    var delegate: FlashCardPlayModelDelegate!
    
    fileprivate var cards = [(Int, String, String)]()
    fileprivate var index = 0
    fileprivate(set) var backCardText: String = ""
    fileprivate(set) var frontCardText: String = ""
    
    init() {
        // Load cards
        let realm = try! Realm()
        let cards = realm.objects(Card.self)
        for card in cards {
            self.cards.append((card.id, card.frontText, card.backText))
        }
        
        // Shuffle cards
        self.cards = self.cards.shuffle()
        self.index = 0
        self.backCardText = ""
        
        if self.cards.count > 0 {
            self.frontCardText = self.cards[index].1
        } else {
            self.frontCardText = ""
        }
    }

    func flipToNext() {
        self.index += 1
        
        if self.cards.count == 0 { return }

        if index >= self.cards.count {
            self.index = self.cards.count
            self.backCardText = self.cards[index-1].2
            self.frontCardText = ""
            
            self.delegate.renderCardsText()
            return
        }
        self.backCardText = self.cards[index-1].2
        self.frontCardText = self.cards[index].1
        
        self.delegate.renderCardsText()
    }

    func flipToPrevious() {
        self.index -= 1
        
        if self.cards.count == 0 { return }
        
        if self.index <= 0 {
            self.index = 0
            self.backCardText = ""
            self.frontCardText = self.cards[index].1
            
            self.delegate.renderCardsText()
            return
        }
        self.backCardText = self.cards[index-1].2
        self.frontCardText = self.cards[index].1
        
        self.delegate.renderCardsText()
    }
}
