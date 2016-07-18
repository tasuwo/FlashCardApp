//
//  RegistCardViewController.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/05.
//  Copyright © 2016年 tasuwo. All rights reserved.
//
// [SwiftでNSNotificationを利用してクラス間の処理を連携する - Qiita](http://qiita.com/taka000826/items/2460869a01766fdd221a

import Cocoa
import RealmSwift

class RegistCardViewController: NSViewController {
    @IBOutlet var registCardView: NSView!
    @IBOutlet var dictionaryContentsField: NSTextView!
    @IBOutlet weak var frontTextField: NSTextField!
    @IBOutlet weak var backTextField: NSTextField!

    override private init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // 決定ボタンが押された時の処理
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(RegistCardViewController.transitionToSearchWordView),
            name: "didPressDecisionKey",
            object: nil)
    }

    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(nibName: "RegistCardViewController", bundle: nil)!
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // TODO: コンストラクタに移す
    var word: String = ""

    func setFrontText(word: String) {
        self.word = word
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // フォーカスの枠を出さない
        self.dictionaryContentsField.focusRingType = NSFocusRingType.None
        self.frontTextField.focusRingType = NSFocusRingType.None
        self.backTextField.focusRingType = NSFocusRingType.None

        // FrontText に入力された単語をセット
        self.frontTextField.stringValue = self.word

        // 辞書内容をセット
        let wisdomPath = "/Library/Dictionaries/Sanseido The WISDOM English-Japanese Japanese-English Dictionary.dictionary"
        if let result = DictionaryServiceManager().lookUp(self.word, inDictionary: wisdomPath) {
            self.dictionaryContentsField.string = result
        } else {
            self.dictionaryContentsField.string = "No result"
        }
    }

    override func viewDidAppear() {
        // 最初に back text にフォーカスさせる
        self.backTextField.becomeFirstResponder()

        // Tab によるフォーカス移動をループさせる
        self.frontTextField.nextKeyView = self.backTextField
        self.backTextField.nextKeyView = self.frontTextField
    }
    
    // MARK: IBAction methods
    
    @IBAction func didPressEnterInBackTextField(sender: AnyObject) {
        self.transitionToSearchWordView()
    }

    // MARK: private methods
    
    @objc
    private func transitionToSearchWordView() {
        saveCard()
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setViewControllerToPopover(SearchWordViewController())
    }

    private func saveCard() {
        let realm = try! Realm()
        let card = Card()
        card.id = Card.lastId(realm)
        card.frontText = self.frontTextField.stringValue
        card.backText = self.backTextField.stringValue
        let holder = CardHolder()

        // デフォルトカードホルダーへ追加
        // TODO : カードホルダーの選択
        holder.id = 0
        let lastCards: List<Card> = CardHolder.lastCards(0, realm: realm)
        holder.cards.appendContentsOf(lastCards)
        holder.cards.append(card)

        try! realm.write {
            realm.add(card)
            realm.add(holder, update: true)
        }
        //print(realm.objects(Card))
        //print(realm.objects(CardHolder).first!.cards)
    }
}
