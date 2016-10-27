//
//  FlashCardPlayView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/20.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

protocol FlashCardPlayViewDelegate {
    func didPressKeyNext()
    func didPressKeyPrevious()
}

class FlashCardPlayView: NSView, FlashCardPlayModelDelegate {
    var delegate: FlashCardPlayViewDelegate!
    var model: FlashCardPlayModel! {
        didSet { self.renderCardsText() }
    }
    
    @IBOutlet var flashCardPlayView: NSView!
    @IBOutlet weak var frontCard: NSCustomTextFieldCell!
    @IBOutlet weak var backCard: NSTextFieldCell!
   
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        Bundle.main.loadNibNamed("FlashCardPlayView", owner: self, topLevelObjects: nil)
        self.frame = self.flashCardPlayView.frame
        addSubview(flashCardPlayView)
        
        self.frontCard.textColor = NSColor.black
        self.backCard.textColor = NSColor.black
        self.frontCard.backgroundColor = NSColor.white
        self.backCard.backgroundColor = NSColor.white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(FlashCardPlayView.nextCard),
            name: NSNotification.Name(rawValue: "didPressNextCardKey"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(FlashCardPlayView.previousCard),
            name: NSNotification.Name(rawValue: "didPressPreviousCardKey"),
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: FlashCardPlayModelDelegate
    
    func renderCardsText() {
        self.frontCard.stringValue = self.model.frontCardText
        self.backCard.stringValue = self.model.backCardText
    }
    
    // MARK: private methods
    
    @objc
    fileprivate func nextCard() {
        self.delegate.didPressKeyNext()
    }
    
    @objc
    fileprivate func previousCard() {
        self.delegate.didPressKeyPrevious()
    }
}
