//
//  FlushCardPlayViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import RealmSwift

class FlashCardPlayViewController: NSViewController {

    @IBOutlet var flashCardPlayView: NSView!
    @IBOutlet weak var previousCardBack: NSTextFieldCell!
    @IBOutlet weak var nowCardFront: NSCustomTextFieldCell!

    var cards = [(Int, String, String)]()
    var index = 0

    override private init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // 決定ボタンが押された時の処理
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(FlashCardPlayViewController.nextCard),
            name: "didPressNextCardKey",
            object: nil)
        // 決定ボタンが押された時の処理
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(FlashCardPlayViewController.previousCard),
            name: "didPressPreviousCardKey",
            object: nil)
        
        loadCards()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(nibName: "FlashCardPlayViewController", bundle: nil)!
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.previousCardBack.textColor = NSColor.blackColor()
        self.previousCardBack.backgroundColor = NSColor.whiteColor()
        self.nowCardFront.textColor = NSColor.blackColor()
        self.nowCardFront.backgroundColor = NSColor.whiteColor()

        self.initForPlaying()
    }

    // MARK: private methods

    private func initForPlaying() {
        self.cards = self.cards.shuffle()
        self.index = 0
        self.previousCardBack.stringValue = ""
        
        if self.cards.count > 0 {
            self.nowCardFront.stringValue = self.cards[index].1
        } else {
            self.nowCardFront.stringValue = ""
        }
    }

    @objc
    private func nextCard() {
        self.index += 1
        
        if self.cards.count == 0 { return }

        if index >= self.cards.count {
            self.index = self.cards.count
            self.previousCardBack.stringValue = self.cards[index-1].2
            self.nowCardFront.stringValue = ""
            return
        }

        self.setCardsText(self.index)
    }

    @objc
    private func previousCard() {
        self.index -= 1
        
        if self.cards.count == 0 { return }
        
        if self.index <= 0 {
            self.index = 0
            self.previousCardBack.stringValue = ""
            self.nowCardFront.stringValue = self.cards[index].1
            return
        }

        self.setCardsText(self.index)
    }
    
    private func setCardsText(index: Int) {
        self.previousCardBack.stringValue = self.cards[index-1].2
        self.nowCardFront.stringValue = self.cards[index].1
    }

    private func loadCards() {
        let realm = try! Realm()
        let cards = realm.objects(Card)
        for card in cards {
            self.cards.append((card.id, card.frontText, card.backText))
        }
    }
}
