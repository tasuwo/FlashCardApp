//
//  PopverOnStatusBar.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/05.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class NSStatusBarPopover: NSPopover {
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var containerViewController: NSViewController!
    private(set) var fromVC: NSViewController!
    private(set) var animating = false

    override init() {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            
            let menu = NSMenu()

            // TODO: アクティブでない場合，キーバインドが効かない
            menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showSettingView), keyEquivalent: ","))
            menu.addItem(NSMenuItem.separatorItem())
            menu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: "q"))
 
            statusItem.menu = menu
        }
        super.init()

        self.containerViewController = BaseViewController()
        self.containerViewController.view.wantsLayer = true

        fromVC = SearchWordViewController()
        self.containerViewController.addChildViewController(self.fromVC)
        self.containerViewController.view.addSubview(self.fromVC.view)
        self.containerViewController.view.frame = self.fromVC.view.bounds

        let navigater = NavigationViewController()
        navigater.addChildViewController(self.containerViewController)
        let navigateView = navigater.view as! NavigationView
        navigateView.contentView.addSubview(self.containerViewController.view)
        self.contentViewController = navigater
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

    func changeViewController(toVC: NSViewController, transition option: NSViewControllerTransitionOptions?, callback: () -> Void) {
        animating = true
        self.containerViewController.addChildViewController(toVC)
        let transition = option == nil ? getTransitionOptionTo(toVC) : option
        self.containerViewController.transitionFromViewController(
            self.fromVC,
            toViewController: toVC,
            options: transition!,
            completionHandler: {
                finished in
                self.fromVC.view.removeFromSuperview()
                self.fromVC.removeFromParentViewController()
                self.fromVC = toVC
                self.animating = false
                callback()
            }
        )
    }

    private func getTransitionOptionTo(toVC: NSViewController) -> NSViewControllerTransitionOptions {
        switch toVC {
        case _ as FlashCardPlayViewController:
            return .SlideLeft
        case _ as SearchWordViewController:
            return .SlideRight
        case _ as RegistCardViewController:
            return .SlideLeft
        default:
            return .None
        }
    }
}
