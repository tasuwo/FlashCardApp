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
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
       
        Bundle.main.loadNibNamed("BaseView", owner: self, topLevelObjects: nil)
        self.frame = self.baseView.frame
        addSubview(self.baseView)
    }
}
