//
//  RegistCardView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import RealmSwift
import WebKit

protocol RegistCardViewDelegate {
    func didPressEnterWith(_ frontText: String, backText: String)
}

class RegistCardView: NSView, RegistCardModelDelegate {
    var delegate: RegistCardViewDelegate!
    var model: RegistCardModel! {
        didSet { self.renderInitialTexts() }
    }
    
    @IBOutlet var registCardView: NSView!
    @IBOutlet var dictionaryContentsField: WebView!
    @IBOutlet weak var frontTextField: NSTextField!
    @IBOutlet weak var backTextField: NSTextField!
    
    @IBAction func didPressEnterInBackTextField(_ sender: AnyObject) {
        self.delegate.didPressEnterWith(self.frontTextField.stringValue, backText: self.backTextField.stringValue)
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        Bundle.main.loadNibNamed("RegistCardView", owner: self, topLevelObjects: nil)
        self.frame = self.registCardView.frame
        addSubview(self.registCardView)
        
         // フォーカスの枠を出さない
        self.dictionaryContentsField.focusRingType = NSFocusRingType.none
        self.frontTextField.focusRingType = NSFocusRingType.none
        self.backTextField.focusRingType = NSFocusRingType.none
        
        // Tab によるフォーカス移動をループさせる
        self.frontTextField.nextKeyView = self.backTextField
        self.backTextField.nextKeyView = self.frontTextField
    }
    
    // MARK: private methods
    
    fileprivate func renderInitialTexts() {
        self.frontTextField.stringValue = self.model.searchedWord
        self.dictionaryContentsField.mainFrame.loadHTMLString(self.model.dictionaryContents, baseURL: nil)
    }
    
    // MARK: RegistCardModelDelegate
    
    func didRegistCard() {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.popover.changeViewController(SearchWordViewController(), transition: nil, callback: {})
    }
}
