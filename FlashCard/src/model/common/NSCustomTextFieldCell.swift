//
//  NSCustomTextField.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/02.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation
import Cocoa
import Carbon

class NSCustomTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        let textHeight: CGFloat = 40.0
        let newRect = NSRect(x: 0, y: (theRect.size.height - textHeight) / 2, width: theRect.size.width, height: textHeight)
        return super.drawingRect(forBounds: newRect)
    }
}
