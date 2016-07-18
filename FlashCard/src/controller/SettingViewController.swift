//
//  SettingViewController.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/17.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class SettingViewController : NSViewController {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var mainView: NSView!
    
    override func viewDidLoad() {
        self.mainView.addSubview(HotKeySettingView(frame: (self.window.contentView?.frame)!))
    }

    @IBAction func selectedTabItem(sender: AnyObject) {
        let item = sender as! NSToolbarItem
        let viewType = item.tag
        var newView: NSView? = nil

        switch(viewType) {
        case 1:
            newView = HotKeySettingView(frame: (self.window.contentView?.frame)!)
        case 2:
            newView = FlashCardsManagerView(frame: (self.window.contentView?.frame)!)
        default:
            return
        }

        let subViews = self.window.contentView?.subviews
        for subView: NSView in subViews! {
            subView.removeFromSuperview()
        }
        self.window.contentView?.addSubview(newView!)
    }

    func show() {
        // 設定画面の表示
        self.window.setIsVisible(true)
        // 設定画面を最前面にする
        self.window.becomeFirstResponder()
    }
}