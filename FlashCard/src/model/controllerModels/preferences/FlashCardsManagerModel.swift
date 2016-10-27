//
//  FlashCardsManagerModel.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import RealmSwift

protocol FlashCardsManagerModelDelegate {
    func reloadTable()
}

class FlashCardsManagerModel : NSObject, NSTableViewDataSource {
    var delegate: FlashCardsManagerModelDelegate!
    fileprivate(set) var holders = List<CardHolder>()
    fileprivate(set) var cards = List<Card>()
    
    func loadCards() {
        let realm = try! Realm()
        let cards = realm.objects(Card.self)
        for card in cards {
            self.cards.append(card)
        }
    }
    
    func getDataAt(_ row: Int, cellID: String, tableView: NSTableView) -> NSView? {
        var i = 0
        var showCard: Card!
        for card in cards {
            if i == row {
                showCard = card
                break
            }
            i += 1
        }

        if showCard == nil {
            return nil
        }

        var showText: String!
        if cellID == "FRONT" {
            showText = showCard.frontText
        } else if cellID == "BACK" {
            showText = showCard.backText
        }

        if showText == nil {
            return nil
        }

        if let cell = tableView.make(withIdentifier: cellID, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = showText
            return cell
        }
        
        return nil
    }
    
    func getCardAt(_ row: Int) -> Card? {
        var i = 0
        var selectedCard: Card?
        for card in cards {
            if i == row {
                selectedCard = card
                break
            }
            i += 1
        }
        return selectedCard
    }
    
    func reloadTable() {
        self.cards = List<Card>()
        self.loadCards()
        self.delegate.reloadTable()
    }
    
    // MARK: NSTableViewDataSource
    
    @objc func numberOfRows(in tableView: NSTableView) -> Int {
        return self.cards.count
    }
}
