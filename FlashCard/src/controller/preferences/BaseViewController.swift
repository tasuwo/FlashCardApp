//
//  BaseViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/09/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class BaseViewController: NSViewController {
    override func loadView() {
        self.view = BaseView()
    }
}