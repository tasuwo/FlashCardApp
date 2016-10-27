//
//  PopverOnStatusBar.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/05.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class NSStatusBarPopover: NSPopover {
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    var containerViewController: NSViewController!
    fileprivate(set) var fromVC: NSViewController!
    fileprivate(set) var animating = false

    override init() {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            
            let menu = NSMenu()

            // TODO: アクティブでない場合，キーバインドが効かない
            menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.showSettingView), keyEquivalent: ","))
            menu.addItem(NSMenuItem.separator())
            // menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSInputServiceProvider.terminate(_:)), keyEquivalent: "q"))
 
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

    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            self.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(_ sender: AnyObject?) {
        self.performClose(sender)
    }

    func togglePopover(_ sender: AnyObject?) {
        if self.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func changeViewController(_ toVC: NSViewController, transition option: NSViewControllerTransitionOptions?, callback: @escaping () -> Void) {
        animating = true
        self.containerViewController.addChildViewController(toVC)
        let transition = option == nil ? getTransitionOptionTo(toVC) : option
        self.containerViewController.transition(
            from: self.fromVC,
            to: toVC,
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

    fileprivate func getTransitionOptionTo(_ toVC: NSViewController) -> NSViewControllerTransitionOptions {
        switch toVC {
        case _ as FlashCardPlayViewController:
            return .slideLeft
        case _ as SearchWordViewController:
            return .slideRight
        case _ as RegistCardViewController:
            return .slideLeft
        default:
            return NSViewControllerTransitionOptions()
        }
    }
}
