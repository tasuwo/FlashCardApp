//
//  DataModels.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/05.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Card: Object {
    dynamic var id = 0
    dynamic var frontText = ""
    dynamic var backText = ""
    let cardHolders = LinkingObjects(fromType: CardHolder.self, property: "cards")

    override static func primaryKey() -> String? {
        return "id"
    }

    static func lastId(realm: Realm) -> Int {
        if let user = realm.objects(Card).sorted("id").last {
            return user.id + 1
        } else {
            return 1
        }
    }
}

class CardHolder: Object {
    dynamic var id = 0
    dynamic var name = ""
    let cards = List<Card>()

    override static func primaryKey() -> String? {
        return "id"
    }

    static func lastId(realm: Realm) -> Int {
        if let holder = realm.objects(CardHolder).last {
            return holder.id + 1
        } else {
            return 1
        }
    }

    static func lastCards(id: Int, realm: Realm) -> List<Card> {
        if let holder = realm.objects(CardHolder).filter("id == \(id)").first {
            return holder.cards
        } else {
            return List<Card>()
        }
    }
}
