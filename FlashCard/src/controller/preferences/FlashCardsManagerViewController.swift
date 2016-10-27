//
//  FlashCardsManagerViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class FlashCardsManagerViewController : NSViewController, FlashCardsManagerViewDelegate {
    fileprivate var parentFrame: CGRect!
    fileprivate var model : FlashCardsManagerModel!
    // 開放されないようにインスタンスを保持
    var controller: NSWindowController! = nil
    
    convenience init(frame: CGRect) {
        self.init()
        self.parentFrame = frame
    }
    
    override func loadView() {
        self.view = FlashCardsManagerView(frame: self.parentFrame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let managerView = self.view as! FlashCardsManagerView
        managerView.delegate = self
        
        self.model = FlashCardsManagerModel()
        self.model.delegate = managerView
        managerView.model = self.model
    }
    
    func didSelectTableRow(_ selectedRow: Int) {
        if let card = self.model.getCardAt(selectedRow) {
            let newVc = EditCardViewController(id: card.id, managerModel: self.model)
            let newWindow = NSWindow(contentViewController: newVc)
            
            self.controller = NSWindowController(window: newWindow)
            self.controller.showWindow(self)
        }
    }
}
