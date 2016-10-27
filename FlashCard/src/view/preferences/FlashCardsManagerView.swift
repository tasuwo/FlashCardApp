//
//  FlushCardsManagerView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import Cocoa
import RealmSwift

protocol FlashCardsManagerViewDelegate {
    func didSelectTableRow(_ selectedRow: Int)
}

class FlashCardsManagerView: NSView, NSTableViewDelegate, FlashCardsManagerModelDelegate {
    var model: FlashCardsManagerModel! {
        didSet {
            self.model.loadCards()
            self.flashCardsTableView.dataSource = self.model
            self.flashCardsTableView.reloadData()
        }
    }
    var delegate: FlashCardsManagerViewDelegate!
    
    @IBOutlet var flashCardsManagerView: NSView!
    @IBOutlet weak var flashCardsTableView: NSTableView!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        Bundle.main.loadNibNamed("FlashCardsManagerView", owner: self, topLevelObjects: nil)
        self.flashCardsManagerView.frame = frameRect
        addSubview(flashCardsManagerView)

        self.flashCardsTableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return self.model.getDataAt(row, cellID: (tableColumn?.identifier)!, tableView: tableView)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.delegate.didSelectTableRow(self.flashCardsTableView.selectedRow)
    }
    
    // MARK: FlashCardManagerModelDelegate
    
    func reloadTable() {
        self.flashCardsTableView.reloadData()
    }
}
