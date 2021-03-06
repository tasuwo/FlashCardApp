//
//  RegistCardViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/05.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import WebKit
import RealmSwift

class RegistCardViewController: NSViewController, RegistCardViewDelegate {
    var searchedWord: String!
    fileprivate var model: RegistCardModel!

    convenience init(searchedWord word: String) {
        self.init()
        self.searchedWord = word
    }
    
    override func loadView() {
        self.view = RegistCardView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let registView = self.view as! RegistCardView
        registView.delegate = self
        
        self.model = RegistCardModel(word: self.searchedWord)
        self.model.delegate = registView
        registView.model = self.model
    }

    override func viewDidAppear() {
        let parentView = self.parent?.parent as? NavigationViewController
        parentView?.updateFirstResponder(self)
    }
    
    // MARK: RegistCardViewDelegate
    
    func didPressEnterWith(_ front: String, backText back: String) {
        self.model.registCard(frontText: front, backText: back)
    }
}
