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

    // 描画する長方形を返す
    override func drawingRectForBounds(theRect: NSRect) -> NSRect {
        var rect: NSRect? = nil

        if  let viewSize = self.controlView?.frame.size {
            let stringSize = self.attributedStringValue.size()
            rect = NSRect(
                x: 1,
                y: (viewSize.height - stringSize.height)/2-1,
                width: viewSize.width-2,
                height: viewSize.height-2
            )
        }

        return rect==nil ? theRect : rect!
    }
    
    
    override func drawInteriorWithFrame(cellFrame: NSRect, inView controlView: NSView) {
        NSColor.whiteColor().setFill()
        NSRectFill(cellFrame)
        super.drawInteriorWithFrame(self.titleRectForBounds(cellFrame), inView: controlView)
    }


    // タイトルテキストを描画する長方形を返す
    override func titleRectForBounds(theRect: NSRect) -> NSRect {
        var titleFrame = super.titleRectForBounds(theRect)
        
        let attrString = self.attributedStringValue
        
        titleFrame.origin.y = titleFrame.size.height - attrString.size().height
        titleFrame.origin.y = titleFrame.size.height/2.0 - attrString.size().height/2.0
        titleFrame.size.height = attrString.size().height*2
        
        return titleFrame
    }
}
