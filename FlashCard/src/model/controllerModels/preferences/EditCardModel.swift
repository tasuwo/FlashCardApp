//
//  EditCardWindow.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import RealmSwift

protocol EditCardModelDelegate {
    func renderInitText()
}

class EditCardModel {
    var delegate: EditCardModelDelegate!
    
    fileprivate(set) var id: Int!
    fileprivate(set) var frontText: String!
    fileprivate(set) var backText: String!
    
    init (id: Int) {
        let realm = try! Realm()
        let card = realm.objects(Card.self).filter("id == \(id)").first
        
        if let targetCard = card {
            self.id = targetCard.id
            self.frontText = targetCard.frontText
            self.backText = targetCard.backText
        } else {
            // TODO: 初期化エラー処理
            return
        }
    }
    
    func deleteCard() {
        let realm = try! Realm()
        try! realm.write {
            let card = realm.objects(Card.self).filter("id == \(self.id)").first!
            realm.delete(card)
        }
    }
    
    func updateCard(frontText front: String, backText back: String) {
        self.frontText = front
        self.backText = back
        
        let realm = try! Realm()
        let card = Card()
        card.id = self.id
        card.frontText = self.frontText
        card.backText = self.backText
        
        try! realm.write {
            realm.add(card, update: true)
        }
    }
}
