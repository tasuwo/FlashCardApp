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
        self.init(frame: CGRectMake(0, 0, 0, 0))
        
        NSBundle.mainBundle().loadNibNamed("FlashCardPlayView", owner: self, topLevelObjects: nil)
        self.frame = self.flashCardPlayView.frame
        addSubview(flashCardPlayView)
        
        self.frontCard.textColor = NSColor.blackColor()
        self.backCard.textColor = NSColor.blackColor()
        self.frontCard.backgroundColor = NSColor.whiteColor()
        self.backCard.backgroundColor = NSColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(FlashCardPlayView.nextCard),
            name: "didPressNextCardKey",
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(FlashCardPlayView.previousCard),
            name: "didPressPreviousCardKey",
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: FlashCardPlayModelDelegate
    
    func renderCardsText() {
        self.frontCard.stringValue = self.model.frontCardText
        self.backCard.stringValue = self.model.backCardText
    }
    
    // MARK: private methods
    
    @objc
    private func nextCard() {
        self.delegate.didPressKeyNext()
    }
    
    @objc
    private func previousCard() {
        self.delegate.didPressKeyPrevious()
    }
}