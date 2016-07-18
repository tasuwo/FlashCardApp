//
//  FlushCardsManagerView.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import Cocoa
import RealmSwift

class FlashCardsManagerView: NSView, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet var flashCardsManagerView: NSView!
    @IBOutlet weak var flashCardsTableView: NSTableView!

    var holders = List<CardHolder>()
    var cards = List<Card>()
    var controller: EditCardWindowController! = nil

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        NSBundle.mainBundle().loadNibNamed("FlashCardsManagerView", owner: self, topLevelObjects: nil)
        self.flashCardsManagerView.frame = frameRect
        addSubview(flashCardsManagerView)

        self.flashCardsTableView.setDelegate(self)
        self.flashCardsTableView.setDataSource(self)

        loadCards()
        self.flashCardsTableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: delegate
    
    func reloadTable() {
        self.cards = List<Card>()
        loadCards()
        self.flashCardsTableView.reloadData()
    }
    
    // MARK: private methods

    private func loadHolders() {
        let realm = try! Realm()
        let holders = realm.objects(CardHolder)
        for holder in holders {
            self.holders.append(holder)
        }
    }

    private func loadCards() {
        let realm = try! Realm()
        let cards = realm.objects(Card)
        for card in cards {
            self.cards.append(card)
        }
    }

    // MARK: NSTableViewDelegate, NSTableViewDataSource

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.cards.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // データを取得
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

        let cellIdentifier = tableColumn?.identifier
        var showText: String!
        if cellIdentifier == "FRONT" {
            showText = showCard.frontText
        } else if cellIdentifier == "BACK" {
            showText = showCard.backText
        }

        if showText == nil {
            return nil
        }

        if let cell = tableView.makeViewWithIdentifier(cellIdentifier!, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = showText
            return cell
        }

        return nil
    }
    
    // セルが選択された時
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = self.flashCardsTableView.selectedRow
        var i = 0
        var selectedCard: Card?
        for card in cards {
            if i == row {
                selectedCard = card
                break
            }
            i += 1
        }
        
        if let card = selectedCard {
            self.controller = EditCardWindowController(
                id: card.id,
                tableView: self.flashCardsTableView)
            self.controller.delegate = self
            self.controller.showWindow(nil)
        } else {
            return
        }
    }
}
