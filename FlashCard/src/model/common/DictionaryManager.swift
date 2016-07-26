//
//  DictionaryManager.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/04.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa

class DictionaryServiceManager {
    private let AppleGlobalDomainName = "Apple Global Domain"
    private let DictionaryServicesKey = "com.apple.DictionaryServices"
    private let ActiveDictionariesKey = "DCSActiveDictionaries"

    private func userDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }

    private func globalDomain() -> [String : AnyObject]? {
        return userDefaults().persistentDomainForName(AppleGlobalDomainName)
    }

    private func dictionaryPreferences() -> [NSObject : AnyObject]? {
        return globalDomain()?[DictionaryServicesKey] as! [NSObject : AnyObject]?
    }

    private func currentDictionaryList() -> [NSString]? {
        // TODO : nil だったら(デフォルト辞書が登録されていなかったら)登録する
        return dictionaryPreferences()?[ActiveDictionariesKey] as! [NSString]?
    }

    // 辞書を設定
    private func setUserDictPreferences(activeDictionaries : [NSString]) {
        if var currentPref = dictionaryPreferences() {
            currentPref[ActiveDictionariesKey] = activeDictionaries
            if var gDomain = globalDomain() {
                gDomain[DictionaryServicesKey] = currentPref
                userDefaults().setPersistentDomain(gDomain, forName: AppleGlobalDomainName)
            }
        }
    }

    func lookUp(word : String, inDictionary dictionaryPath : String) -> String? {
        // 現在の辞書設定を保存
        let currentPrefs = currentDictionaryList()

        // 辞書設定を検索対象のものに更新
        setUserDictPreferences([dictionaryPath])

        // 検索
        let result : String? = DCSCopyTextDefinition(nil, word, CFRangeMake(0, (word as NSString).length))?.takeRetainedValue() as String?

        // 辞書設定を検索以前のものに戻す
        if currentPrefs != nil {
            setUserDictPreferences(currentPrefs!)
        }

        return result
    }
}
