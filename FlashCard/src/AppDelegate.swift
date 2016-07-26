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

    @IBAction func selectedTabItem(sender: AnyObject) {
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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.mainView.addSubview(HotKeySettingView(frame: (self.window.contentView?.frame)!))
        self.window.contentView = self.mainView

        initHotKeyActions()

        let realm = try! Realm()
        let defaultHolder = realm.objects(CardHolder).filter("id == 0")

        // DEBUG:
        //try! realm.write {
        //    realm.deleteAll()
        //}

        if defaultHolder.count == 0 {
            let cardHolder = CardHolder()
            cardHolder.id = 0
            cardHolder.name = "default"
            try! realm.write {
                realm.add(cardHolder)
            }
        }

        self.setViewControllerToPopover(SearchWordViewController())
    }

    // MARK: control popover methods

    func setViewControllerToPopover(vc: NSViewController) {
        self.popover.contentViewController?.view.frame = vc.view.frame
        self.popover.contentViewController = vc
    }

    func togglePopover() {
        self.popover.togglePopover(nil)
    }
    
    func showSettingView() {
        // 設定画面の表示
        self.window.setIsVisible(true)
        // popver をしまう
        if self.popover.shown {
            self.togglePopover()
        }
        // 設定画面を最前面にする
        self.window.becomeFirstResponder()
    }

    // MARK: private methods

    private func switchPopover(nextViewController: NSViewController.Type) {
        var willChangeView = false
        let willShowView = !self.popover.shown

        if self.popover.contentViewController!.isKindOfClass(nextViewController as AnyClass) == false {
            willChangeView = true
        }

        if willChangeView == true && willShowView == false {
            self.setViewControllerToPopover(nextViewController.init())
        } else if willChangeView == true && willShowView == true {
            self.popover.togglePopover(nil)
            self.setViewControllerToPopover(nextViewController.init())
        } else {
            self.popover.togglePopover(nil)
        }
        // popver をアクティブにする
        if self.popover.shown {
            NSApplication.sharedApplication().activateIgnoringOtherApps(true)
        }
    }

    private func initHotKeyActions() {
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(
            kPreferenceShortcut.launch.rawValue,
            toAction: { self.switchPopover(SearchWordViewController) }
        )
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(
            kPreferenceShortcut.flushCard.rawValue,
            toAction: { self.switchPopover(FlashCardPlayViewController)}
        )
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(
            kPreferenceShortcut.nextCard.rawValue,
            toAction: {
                let notification : NSNotification = NSNotification(name: "didPressNextCardKey", object: self)
                NSNotificationCenter.defaultCenter().postNotification(notification)
        })
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(
            kPreferenceShortcut.previousCased.rawValue,
            toAction: {
                let notification : NSNotification = NSNotification(name: "didPressPreviousCardKey", object: self)
                NSNotificationCenter.defaultCenter().postNotification(notification)
        })
    }
}
