//
//  NavigationViewController.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/09/06.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

class NavigationViewController: NSViewController {
    var containerViewController: NSViewController!
    fileprivate(set) var fromVC: NSViewController!

    override func loadView() {
        self.containerViewController = BaseViewController()
        self.containerViewController.view.wantsLayer = true

        fromVC = SearchWordViewController()
        self.containerViewController.addChildViewController(self.fromVC)
        self.containerViewController.view.addSubview(self.fromVC.view)
        self.containerViewController.view.frame = self.fromVC.view.bounds

        let navigateView = NavigationView()
        self.addChildViewController(self.containerViewController)
        navigateView.contentView.addSubview(self.containerViewController.view)
        self.view = navigateView
    }

    override func viewDidAppear() {
        let baseVC = self.childViewControllers.first
        let contentVC = baseVC?.childViewControllers.first
        updateFirstResponder(contentVC!)
    }

    func changeViewController(_ toVC: NSViewController, transition option: NSViewControllerTransitionOptions?, callback: @escaping () -> Void) {
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
                callback()
        }
        )
    }

    func updateFirstResponder(_ contentViewController: NSViewController) {
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
