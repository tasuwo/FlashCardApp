//
//  CustomTableView.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/08.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class CustomTableView : NSTableView {
    override func textDidChange(notification: NSNotification) {
        Swift.print("test")
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        Swift.print("aa")
    }
    
    override func textDidEndEditing(notification: NSNotification) {
        Swift.print("test")
    }
}