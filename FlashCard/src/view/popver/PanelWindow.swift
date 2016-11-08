//
//  PanelWindow.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/11/08.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class PanelWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }

    override var acceptsFirstResponder: Bool {
        return true
    }
}
