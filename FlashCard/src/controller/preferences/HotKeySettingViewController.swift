//
//  HotKeysettingView.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/26.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation


class HotKeySettingViewController: NSViewController {
    private var parentFrame: CGRect!
    
    convenience init(frame: CGRect) {
        self.init()
        self.parentFrame = frame
    }
    
    override func loadView() {
        self.view = HotKeySettingView(frame: self.parentFrame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}