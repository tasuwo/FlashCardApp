//
//  NavigationViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/09/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class NavigationViewController: NSViewController {
    override func loadView() {
        self.view = NavigationView()
    }

    override func viewDidAppear() {
        let baseVC = self.childViewControllers.first
        let contentVC = baseVC?.childViewControllers.first

        updateFirstResponder(contentVC!)
    }

    func updateFirstResponder(contentViewController: NSViewController) {
        switch contentViewController {
        case let vc as SearchWordViewController:
            let view = vc.view as! SearchWordView
            view.inputWordField.becomeFirstResponder()
        case let vc as FlashCardPlayViewController:
            let _ = vc.view as! FlashCardPlayView
        case let vc as RegistCardViewController:
            let view = vc.view as! RegistCardView
            view.backTextField.becomeFirstResponder()
        default:
            break
        }
    }
}