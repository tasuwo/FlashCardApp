//
//  SearchWordViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/02.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import RealmSwift

class SearchWordViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var inputWordField: NSTextField!
    @IBOutlet var dictionaryContentsField: NSTextView!
    @IBOutlet weak var settingsButton: NSButton!

    override private init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(SearchWordViewController.transitToRegistView),
            name: "didPressDecisionKey",
            object: nil)
    }

    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(nibName: "SearchWordViewController", bundle: nil)!
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        inputWordField.delegate = self

        self.inputWordField.focusRingType = NSFocusRingType.None
        self.dictionaryContentsField.focusRingType = NSFocusRingType.None
        self.settingsButton.focusRingType = NSFocusRingType.None
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.inputWordField.becomeFirstResponder()
    }

    // MARK: IBAction methods
    
    @IBAction func didPressSettingsButton (sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showSettingView()
    }
    
    @IBAction func didPressEnterButtonInInputTextField (sender: AnyObject) {
        self.transitToRegistView()
    }
    
    // MARK: private methods

    @objc
    private func transitToRegistView() {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let vc = RegistCardViewController()
        vc.setFrontText(self.inputWordField.stringValue)
        appDelegate.setViewControllerToPopover(vc)
    }

    // MARK: NSTextFieldDelegate

    override func controlTextDidChange(obj: NSNotification) {
        // TODO : 辞書設定
        let wisdomPath = "/Library/Dictionaries/Sanseido The WISDOM English-Japanese Japanese-English Dictionary.dictionary"
        let word: String = inputWordField.stringValue

        if let result = DictionaryServiceManager().lookUp(word, inDictionary: wisdomPath) {
            self.dictionaryContentsField.string = result
        } else {
            dictionaryContentsField.string = "No result"
        }
    }
}
