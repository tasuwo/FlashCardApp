//
//  NavigationView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/09/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class NavigationView : NSView {
    @IBOutlet var navigationView: PanelBackground!
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var settingButton: NSButton!
    @IBAction func didPressSettingButton(_ sender: AnyObject) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.showSettingView()
    }

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
       
        Bundle.main.loadNibNamed("NavigationView", owner: self, topLevelObjects: nil)
        self.frame = self.navigationView.frame
        addSubview(self.navigationView)

        // フォーカスの枠をださない
        self.settingButton.focusRingType = NSFocusRingType.none
    }
}
