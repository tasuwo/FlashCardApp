//
//  StatusBarItem.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/11/08.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import Foundation

class StatusBarItem: NSObject {
    let WIDTH: CGFloat = 24.4
    let statusItem: NSStatusItem

    override init() {
        self.statusItem = NSStatusBar.system().statusItem(withLength: WIDTH)

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showSettingView), keyEquivalent: ","))
        // menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSInputServiceProvider.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    func getRect() -> NSRect {
        return statusItem.button!.window!.frame
    }
}
