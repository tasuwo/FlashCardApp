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
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var mainView: NSView!

    var popover: NSStatusBarPopover = NSStatusBarPopover()

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

    // MARK: control popover methods

    func togglePopover() {
        self.popover.togglePopover(nil)
    }
    
    func showSettingView() {
        // 設定画面の表示
        self.window.setIsVisible(true)
        // popver をしまう
        if self.popover.isShown {
            self.togglePopover()
        }
        // 設定画面を最前面にする
        self.window.becomeFirstResponder()
    }

    // MARK: private methods

    fileprivate func switchPopover(_ nextViewController: NSViewController.Type) {
        var shouldChangeView = false
        let isPopoverShown = self.popover.isShown
        if self.popover.fromVC.isKind(of: nextViewController as AnyClass) == false {
            shouldChangeView = true
        }
        var option: NSViewControllerTransitionOptions? = nil
        var toggle = {
            let appDelegate = NSApplication.shared().delegate as! AppDelegate
            appDelegate.popover.togglePopover(nil)
        }

        // view の切替時にはトグルしない
        if isPopoverShown && shouldChangeView {
            toggle = {}
        }

        if isPopoverShown == false {
            option = .none
        }

        if shouldChangeView {
            self.popover.changeViewController(nextViewController.init(), transition: option, callback: toggle)
        } else {
            toggle()
        }

        // popver をアクティブにする
        if self.popover.isShown {
            NSApplication.shared().activate(ignoringOtherApps: true)
        }
    }

    fileprivate func initHotKeyActions() {
        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: kPreferenceShortcut.launch.rawValue,
            toAction: {
                if (!self.popover.animating) {
                    self.switchPopover(SearchWordViewController.self)
                }
            }
        )
        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: kPreferenceShortcut.flushCard.rawValue,
            toAction: {
                if (!self.popover.animating) {
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
