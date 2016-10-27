//
//  EditCardViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/24.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class EditCardViewController: NSViewController, EditCardDelegate {
    var targetCardID: Int!
    var managerModel: FlashCardsManagerModel!
    var model: EditCardModel!
   
    convenience init(id: Int, managerModel model: FlashCardsManagerModel) {
        self.init()
        self.targetCardID = id
        self.managerModel = model
    }
    
    override func loadView() {
        self.view = EditCardView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editView = self.view as! EditCardView
        editView.editCardDelegate = self
        
        self.model = EditCardModel(id: self.targetCardID)
        self.model.delegate = editView
        editView.model = self.model
    }

    // MARK: EditCardDelegate
    
    func didPressDelete() {
        self.model.deleteCard()
        self.managerModel.reloadTable()
        self.view.window?.close()
    }
    
    func didPressUpdate(_ front: String, backtext back: String) {
        self.model.updateCard(frontText: front, backText: back)
        self.managerModel.reloadTable()
        self.view.window?.close()
    }
}
