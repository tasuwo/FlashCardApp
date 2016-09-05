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
    func didCangeText(text: String)
}

class SearchWordView : NSView, NSTextFieldDelegate, SearchWordModelDelegate {
    var delegate: SearchWordViewDelegate!
    var model: SearchWordModel!
    
    @IBOutlet var searchWordView: NSView!
    @IBOutlet weak var inputWordField: NSTextField!
    @IBOutlet var dictionaryContentsField: WebView!

    @IBAction func didPressEnterButtonInInputTextField (sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let vc = RegistCardViewController(searchedWord: self.inputWordField.stringValue)
        appDelegate.setViewControllerToPopover(vc)
    }
    
    convenience init() {
        self.init(frame: CGRectMake(0, 0, 0, 0))
       
        NSBundle.mainBundle().loadNibNamed("SearchWordView", owner: self, topLevelObjects: nil)
        self.frame = self.searchWordView.frame
        addSubview(self.searchWordView)
        
        inputWordField.delegate = self

        self.inputWordField.focusRingType = NSFocusRingType.None
        self.dictionaryContentsField.focusRingType = NSFocusRingType.None
    }
    
    // MARK: NSTextFieldDelegate

    override func controlTextDidChange(obj: NSNotification) {
        self.delegate.didCangeText(self.inputWordField.stringValue)
    }
    
    // MARK: SearchWordModelDelegate
    
    func renderLookUpResult() {
        self.dictionaryContentsField.mainFrame.loadHTMLString(self.model.lookupResult, baseURL: nil)
    }
}