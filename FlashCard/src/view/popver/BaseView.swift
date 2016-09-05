//
//  BaseView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/09/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class BaseView : NSView {
    @IBOutlet var baseView: NSView!

    convenience init() {
        self.init(frame: CGRectMake(0, 0, 0, 0))
       
        NSBundle.mainBundle().loadNibNamed("BaseView", owner: self, topLevelObjects: nil)
        self.frame = self.baseView.frame
        addSubview(self.baseView)
    }
}
