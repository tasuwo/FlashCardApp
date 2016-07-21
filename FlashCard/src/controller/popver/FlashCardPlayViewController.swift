//
//  FlushCardPlayViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import RealmSwift

class FlashCardPlayViewController: NSViewController, FlashCardPlayViewDelegate {
    var model: FlashCardPlayModel!
   
    override func loadView() {
        self.view = FlashCardPlayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let playView = self.view as! FlashCardPlayView
        playView.delegate = self
        
        self.model = FlashCardPlayModel()
        self.model.delegate = playView
        playView.model = self.model
    }
      
    // MARK: FlashCardPlayViewDelegate
    
    func didPressKeyNext() {
        self.model.flipToNext()
    }
    
    func didPressKeyPrevious() {
        self.model.flipToPrevious()
    }
}
