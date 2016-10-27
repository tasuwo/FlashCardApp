//
//  RegistCardModel.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import RealmSwift

protocol RegistCardModelDelegate {
    func didRegistCard()
}

class RegistCardModel {
    var delegate: RegistCardModelDelegate!    
    fileprivate(set) var searchedWord: String
    fileprivate(set) var dictionaryContents: String
    
    init(word: String) {
        self.searchedWord = word
        
        // 辞書内容をセット
        let wisdomPath = "/Library/Dictionaries/Sanseido The WISDOM English-Japanese Japanese-English Dictionary.dictionary"
        if let result = DictionaryServiceManager().lookUp(self.searchedWord, inDictionary: wisdomPath) {
            self.dictionaryContents = DictionaryServiceManager().parseResultToHTML(result)
        } else {
            self.dictionaryContents = "No result"
        }
    }
    
    func registCard(frontText front: String, backText back: String) {
        let realm = try! Realm()
        let card = Card()
        card.id = Card.lastId(realm)
        card.frontText = front
        card.backText = back
        let holder = CardHolder()

        // デフォルトカードホルダーへ追加
        // TODO : カードホルダーの選択
        holder.id = 0
        let lastCards: List<Card> = CardHolder.lastCards(0, realm: realm)
        holder.cards.append(objectsIn: lastCards)
        holder.cards.append(card)

        try! realm.write {
            realm.add(card)
            realm.add(holder, update: true)
        }
        
        self.delegate.didRegistCard()
    }
}
