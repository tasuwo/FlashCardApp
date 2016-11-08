//
//  StatusBarController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/11/08.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import Cocoa

class StatusBarController: NSObject {
    let view: StatusBarItem

    override init() {
        self.view = StatusBarItem()
    }
}
