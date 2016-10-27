//
//  SearchWordViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/02.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import WebKit
import RealmSwift

class SearchWordViewController: NSViewController, SearchWordViewDelegate {
    fileprivate var model : SearchWordModel!
    
    override func loadView() {
        self.view = SearchWordView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let searchView = self.view as! SearchWordView
        searchView.delegate = self
        
        self.model = SearchWordModel()
        self.model.delegate = searchView
        searchView.model = self.model
    }
    
    override func viewDidAppear() {
        let parentView = self.parent?.parent as? NavigationViewController
        parentView?.updateFirstResponder(self)
    }

    // MARK: SearchWordViewDelegate
    
    func didCangeText(_ text: String) {
        self.model.lookup(text)
    }
}
