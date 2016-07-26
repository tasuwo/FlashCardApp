//
//  SettingsViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/04.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa

enum kPreferenceShortcut: String {
    case launch        = "launch"
    case flushCard     = "flushCard"
    case nextCard      = "nextCard"
    case previousCased = "previousCard"
    case decision      = "decision"
}

class HotKeySettingView: NSView {

    @IBOutlet var hotKeySettingView: NSView!
    @IBOutlet weak var launchApplicationKey: MASShortcutView!
    @IBOutlet weak var launchFlushCardKey: MASShortcutView!
    @IBOutlet weak var nextCardKey: MASShortcutView!
    @IBOutlet weak var previousCardKey: MASShortcutView!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        NSBundle.mainBundle().loadNibNamed("HotKeySettingView", owner: self, topLevelObjects: nil)
        self.hotKeySettingView.frame = frameRect

        self.hotKeySettingView.addSubview(self.launchApplicationKey)
        addSubview(self.hotKeySettingView)

        // 既に登録されたキーをセット
        self.launchApplicationKey.associatedUserDefaultsKey = kPreferenceShortcut.launch.rawValue
        self.launchFlushCardKey.associatedUserDefaultsKey = kPreferenceShortcut.flushCard.rawValue
        self.nextCardKey.associatedUserDefaultsKey = kPreferenceShortcut.nextCard.rawValue
        self.previousCardKey.associatedUserDefaultsKey = kPreferenceShortcut.previousCased.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
