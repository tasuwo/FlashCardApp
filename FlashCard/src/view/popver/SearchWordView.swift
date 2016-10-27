//
//  SearchWordView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import WebKit

protocol SearchWordViewDelegate {
    func didCangeText(_ text: String)
}

class SearchWordView : NSView, NSTextFieldDelegate, SearchWordModelDelegate {
    var delegate: SearchWordViewDelegate!
    var model: SearchWordModel!
    
    @IBOutlet var searchWordView: NSView!
    @IBOutlet weak var inputWordField: NSTextField!
    @IBOutlet var dictionaryContentsField: WebView!

    @IBAction func didPressEnterButtonInInputTextField (_ sender: AnyObject) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        let vc = RegistCardViewController(searchedWord: self.inputWordField.stringValue)
        appDelegate.popover.changeViewController(vc, transition: nil, callback: {})
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
       
        Bundle.main.loadNibNamed("SearchWordView", owner: self, topLevelObjects: nil)
        self.frame = self.searchWordView.frame
        addSubview(self.searchWordView)
        
        inputWordField.delegate = self

        self.inputWordField.focusRingType = NSFocusRingType.none
        self.dictionaryContentsField.focusRingType = NSFocusRingType.none
    }
    
    // MARK: NSTextFieldDelegate

    override func controlTextDidChange(_ obj: Notification) {
        self.delegate.didCangeText(self.inputWordField.stringValue)
    }
    
    // MARK: SearchWordModelDelegate
    
    func renderLookUpResult() {
        self.dictionaryContentsField.mainFrame.loadHTMLString(self.model.lookupResult, baseURL: nil)
    }
}
