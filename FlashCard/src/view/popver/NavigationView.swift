//
//  NavigationView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/09/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class NavigationView : NSView {
    @IBOutlet var navigationView: NSView!
    @IBOutlet weak var contentView: NSView!

    convenience init() {
        self.init(frame: CGRectMake(0, 0, 0, 0))
       
        NSBundle.mainBundle().loadNibNamed("NavigationView", owner: self, topLevelObjects: nil)
        self.frame = self.navigationView.frame
        addSubview(self.navigationView)
    }
}