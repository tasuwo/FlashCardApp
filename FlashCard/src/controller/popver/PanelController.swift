//
//  PanelController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/11/08.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import Foundation

protocol PanelControllerDelegate {
    func statusItemViewRectForPanelController() -> NSRect
}

class PanelController: NSWindowController, NSWindowDelegate {
    let POPUP_HIEGHT = 122
    let RIGHT_MARGIN: CGFloat = 8
    let ARROW_X: CGFloat = 12

    fileprivate(set) var animating = false

    var delegate: PanelControllerDelegate?
    var navigationView: NavigationView?

    convenience init(delegate: PanelControllerDelegate?) {
        let panel = NSWindow(contentViewController: NavigationViewController())
        self.init(window: panel)

        panel.hasShadow = false
        panel.styleMask = [.borderless]
        panel.acceptsMouseMovedEvents = true
        panel.isOpaque = false
        panel.backgroundColor = .clear

        animating = false

        self.delegate = delegate
        self.navigationView = panel.contentView as? NavigationView
    }

    func openPanel() {
        let panel = self.window!

        let screenRect = NSScreen.screens()!.first!.frame
        let statusRect = self.delegate!.statusItemViewRectForPanelController()
        var panelRect = self.window!.frame
        panelRect.origin.x = statusRect.minX
        panelRect.origin.y = statusRect.midY - panelRect.height

        if panelRect.maxX > screenRect.maxX {
            self.navigationView?.navigationView.setArrowX(value: ARROW_X + (panelRect.maxX - screenRect.maxX + RIGHT_MARGIN))
            panelRect.origin.x = screenRect.maxX - panelRect.width - RIGHT_MARGIN
        } else {
            self.navigationView?.navigationView.setArrowX(value: ARROW_X)
        }

        panel.setFrame(panelRect, display: true, animate: true)

        self.window?.alphaValue = 0
        self.window?.makeKeyAndOrderFront(nil)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.3
            self.window?.animator().alphaValue = 1
        }, completionHandler: nil
        )
        NSApp.activate(ignoringOtherApps: true)
    }

    func closePanel() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.3
            self.window?.animator().alphaValue = 0
        }, completionHandler: { self.window?.orderOut(self) }
        )
    }

     func changeViewController(_ toVC: NSViewController, transition option: NSViewControllerTransitionOptions?, callback: @escaping () -> Void) {
        self.animating = true
        let vc = self.window?.contentViewController as! NavigationViewController
        vc.changeViewController(toVC, transition: option, callback: {
            self.animating = false
            callback()
        })
    }

    func getShownViewController() -> NSViewController {
        let vc = self.window?.contentViewController as! NavigationViewController
        return vc.fromVC
    }
}

