//
//  PopverOnStatusBar.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/05.
//  Copyright © 2016年 tasuwo. All rights reserved.
//
// [sender: AnyObject?](https://www.raywenderlich.com/98178/os-x-tutorial-menus-popovers-menu-bar-apps)
// [http://qiita.com/eielh/items/83dfd775558bd5a4bb25](https://teratail.com/questions/16588)

import Foundation

class NSStatusBarPopover: NSPopover {
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)

    override init() {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            
            let menu = NSMenu()

            // TODO: アクティブでない場合，キーバインドが効かない
            menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showSettingView), keyEquivalent: ","))
            menu.addItem(NSMenuItem.separatorItem())
            menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
 
            statusItem.menu = menu
        }
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            self.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }

    func closePopover(sender: AnyObject?) {
        self.performClose(sender)
    }

    func togglePopover(sender: AnyObject?) {
        if self.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}
