//
//  EditCardView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/24.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift

protocol EditCardDelegate {
    func didPressDelete()
    func didPressUpdate(_ frontText: String, backtext: String)
}

class EditCardView: NSView, EditCardModelDelegate {
    var editCardDelegate: EditCardDelegate!
    var model: EditCardModel! {
        didSet { self.renderInitText() }
    }
    
    @IBOutlet var editCardView: NSView!
    @IBOutlet weak var frontTextEditField: NSCustomTextFieldCell!
    @IBOutlet weak var backTextEditField: NSCustomTextFieldCell!
    @IBAction func didPressDelete(_ sender: AnyObject) {
        self.editCardDelegate.didPressDelete()
    }
    @IBAction func didPressUpdate(_ sender: AnyObject) {
        self.editCardDelegate.didPressUpdate(self.frontTextEditField.stringValue, backtext: self.backTextEditField.stringValue)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        Bundle.main.loadNibNamed("EditCardView", owner: self, topLevelObjects: nil)
        self.frame = self.editCardView.frame
        addSubview(self.editCardView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: EditCardModelDelegate
    
    func renderInitText() {
        self.frontTextEditField.stringValue = self.model.frontText
        self.backTextEditField.stringValue = self.model.backText
    }
}
