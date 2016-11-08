//
//  AppDelegate.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/02.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PanelControllerDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var mainView: NSView!
    var statusbarController: StatusBarController!
    var panelController: PanelController!

    @IBAction func selectedTabItem(_ sender: AnyObject) {
        let item = sender as! NSToolbarItem
        let viewType = item.tag
        var newViewController: NSViewController? = nil

        switch(viewType) {
        case 1:
            newViewController = HotKeySettingViewController(frame: (self.window.contentView?.frame)!)
        case 2:
            newViewController = FlashCardsManagerViewController(frame: (self.window.contentView?.frame)!)
        default:
            return
        }

        self.window.contentViewController = newViewController
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.mainView.addSubview(HotKeySettingView(frame: (self.window.contentView?.frame)!))
        self.window.contentView = self.mainView
        self.statusbarController = StatusBarController()
        self.panelController = PanelController(delegate: self)

        initHotKeyActions()

        let realm = try! Realm()
        let defaultHolder = realm.objects(CardHolder.self).filter("id == 0")
        if defaultHolder.count == 0 {
            let cardHolder = CardHolder()
            cardHolder.id = 0
            cardHolder.name = "default"
            try! realm.write {
                realm.add(cardHolder)
            }
        }
    }

    func statusItemViewRectForPanelController() -> NSRect {
        return self.statusbarController.view.getRect()
    }

    // MARK: control popover methods

    func togglePopover() {
        if self.panelController.window!.isVisible {
            self.panelController.closePanel()
        } else {
            self.panelController.openPanel()
        }
    }

    func applicationDidResignActive(_ notification: Notification) {
        self.panelController.closePanel()
    }
    
    func showSettingView() {
        // 設定画面の表示
        self.window.setIsVisible(true)
        // popver をしまう
        if self.panelController.window!.isVisible {
            self.panelController.closePanel()
        }
        // 設定画面を最前面にする
        self.window.becomeFirstResponder()
    }

    // MARK: private methods

    fileprivate func switchPopover(_ nextViewController: NSViewController.Type) {
        var shouldChangeView = false
        let isPopoverShown = self.panelController.window!.isVisible
        if self.panelController.getShownViewController().isKind(of: nextViewController as AnyClass) == false {
            shouldChangeView = true
        }
        var option: NSViewControllerTransitionOptions? = nil
        var toggle = {
            let appDelegate = NSApplication.shared().delegate as! AppDelegate
            // WARNING: ちょくせつトグルすべき？
            appDelegate.togglePopover()
        }

        // view の切替時にはトグルしない
        if isPopoverShown && shouldChangeView {
            toggle = {}
        }

        if isPopoverShown == false {
            option = .none
        }

        if shouldChangeView {
            self.panelController.changeViewController(nextViewController.init(), transition: option, callback: toggle)
        } else {
            toggle()
        }

        // popver をアクティブにする
        if self.panelController.window!.isVisible {
            NSApplication.shared().activate(ignoringOtherApps: true)
        }
    }

    fileprivate func initHotKeyActions() {
        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: kPreferenceShortcut.launch.rawValue,
            toAction: {
                if (!self.panelController.animating) {
                    self.switchPopover(SearchWordViewController.self)
                }
            }
        )
        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: kPreferenceShortcut.flushCard.rawValue,
            toAction: {
                if (!self.panelController.animating) {
                    self.switchPopover(FlashCardPlayViewController.self)
                }
            }
        )
        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: kPreferenceShortcut.nextCard.rawValue,
            toAction: {
                let notification : Notification = Notification(name: Notification.Name(rawValue: "didPressNextCardKey"), object: self)
                NotificationCenter.default.post(notification)
        })
        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: kPreferenceShortcut.previousCased.rawValue,
            toAction: {
                let notification : Notification = Notification(name: Notification.Name(rawValue: "didPressPreviousCardKey"), object: self)
                NotificationCenter.default.post(notification)
        })
    }
}
