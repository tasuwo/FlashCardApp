//
//  EditCardView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/08.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import RealmSwift

class EditCardWindowController: NSWindowController {
    
    @IBOutlet var editCardWindow: NSWindow!
    @IBOutlet var editCardView: NSView!
    @IBOutlet weak var frontTextEditField: NSCustomTextFieldCell!
    @IBOutlet weak var backTextEditField: NSCustomTextFieldCell!
    
    var delegate: FlashCardsManagerView!
   
    private var targetCard: [String:AnyObject] = [
        "id": -1,
        "frontText": "",
        "backText": ""
    ]
    
    override private init(window: NSWindow?) {
        super.init(window: window)
    }
    
    convenience init(id: Int, tableView: NSTableView) {
        self.init(window: NSWindow())
        
        NSBundle.mainBundle().loadNibNamed("EditCardWindow", owner: self, topLevelObjects: nil)
        self.window = self.editCardWindow
        initView(id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private methods
    
    private func initView(id: Int) {
        let realm = try! Realm()
        let card = realm.objects(Card).filter("id == \(id)").first
        
        if let targetCard = card {
            self.targetCard["id"] = targetCard.id
            self.targetCard["frontText"] = targetCard.frontText
            self.targetCard["backText"] = targetCard.backText
            self.frontTextEditField.stringValue = targetCard.frontText
            self.backTextEditField.stringValue = targetCard.backText
        } else {
            // TODO: 初期化エラー処理
            return
        }
    }
    
    // MARK: IBAction methods
    
    @IBAction func didEditFrontText(sender: AnyObject) {
        self.targetCard["frontText"] = self.frontTextEditField.stringValue
    }
    
    @IBAction func didEditBackText(sender: AnyObject) {
        self.targetCard["backText"] = self.backTextEditField.stringValue
    }
    
    @IBAction func didPressDelete(sender: AnyObject) {
        let realm = try! Realm()
        try! realm.write {
            let card = realm.objects(Card).filter("id == \(self.targetCard["id"]!)").first!
            realm.delete(card)
        }
        
        self.delegate.reloadTable()
        self.close()
    }
    
    @IBAction func didPressUpdate(sender: AnyObject) {
        self.targetCard["frontText"] = self.frontTextEditField.stringValue
         self.targetCard["backText"] = self.backTextEditField.stringValue
        
        let realm = try! Realm()
        let card = Card()
        card.id = self.targetCard["id"] as! Int
        card.frontText = self.targetCard["frontText"] as! String
        card.backText = self.targetCard["backText"] as! String

        try! realm.write {
            realm.add(card, update: true)
        }
       
        self.delegate.reloadTable()
        self.close()
    }
}