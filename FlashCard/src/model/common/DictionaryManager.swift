//
//  DictionaryManager.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/04.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Cocoa
import Foundation
import WebKit

class DictionaryServiceManager {
    fileprivate let AppleGlobalDomainName = "Apple Global Domain"
    fileprivate let DictionaryServicesKey = "com.apple.DictionaryServices"
    fileprivate let ActiveDictionariesKey = "DCSActiveDictionaries"

    fileprivate func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }

    fileprivate func globalDomain() -> [String : AnyObject]? {
        return userDefaults().persistentDomain(forName: AppleGlobalDomainName) as [String : AnyObject]?
    }

    fileprivate func dictionaryPreferences() -> [AnyHashable: Any]? {
        return globalDomain()?[DictionaryServicesKey] as! [AnyHashable: Any]?
    }

    fileprivate func currentDictionaryList() -> [NSString]? {
        // TODO : nil だったら(デフォルト辞書が登録されていなかったら)登録する
        return dictionaryPreferences()?[ActiveDictionariesKey] as! [NSString]?
    }

    fileprivate func setUserDictPreferences(_ activeDictionaries : [NSString]) {
        if var currentPref = dictionaryPreferences() {
            currentPref[ActiveDictionariesKey] = activeDictionaries
            if var gDomain = globalDomain() {
                gDomain[DictionaryServicesKey] = currentPref as AnyObject?
                userDefaults().setPersistentDomain(gDomain, forName: AppleGlobalDomainName)
            }
        }
    }

    func lookUp(_ word : String, inDictionary dictionaryPath : String) -> String? {
        // 現在の辞書設定を保存
        let currentPrefs = currentDictionaryList()

        // 辞書設定を検索対象のものに更新
        setUserDictPreferences([dictionaryPath as NSString])

        // 検索
        let result : String? = DCSCopyTextDefinition(nil, word as CFString, CFRangeMake(0, (word as NSString).length))?.takeRetainedValue() as String?

        // 辞書設定を検索以前のものに戻す
        if currentPrefs != nil {
            setUserDictPreferences(currentPrefs!)
        }

        return result
    }
    
    func parseResultToHTML(_ result: String) -> String {
        var body = ""
        
        let tmp1 = result.componentsSeparatedByAfterStringAt("/", num: 2)
        let tmp2 = tmp1[0].componentsSeparatedByBeforeStringAt("/", num: 1)
        let word = tmp2[0]
        let pronunce = tmp2.count >= 2 ? tmp2[1] : ""
        var definision = tmp1.count >= 2 ? tmp1[1] : ""
        var etymology = ""
        
        let tmp3 = definision.componentsSeparatedByAfterStringAt("〗", num: 1)
        if tmp3.count > 1 {
            etymology = tmp3[0] + "<br>"
            definision = tmp3[1]
        }

        // ▸ で改行
        let bulletPoints = definision.componentsSeparatedByBeforeString("▸")
        var definisionArray: [String] = [bulletPoints[0]+"<br>"]
        var isFirstLine = true
        for bulletPoint in bulletPoints {
            if isFirstLine {
                isFirstLine = false
                continue
            }
            // TODO: 最初にマッチしたもののみ置換する
            /*let pattern = "([a-zA-Z0-9\\s\\[\\].〜]+)"
            let replace = "$1<br>"
            definisionArray.append(bulletPoint.stringByReplacingOccurrencesOfString(
                pattern,
                withString: replace,
                options: NSStringCompareOptions.RegularExpressionSearch,
                range: nil))*/
            definisionArray.append(bulletPoint)
            definisionArray.append("<br>")
        }
        definision = definisionArray.joined(separator: "")
        
        // 段落
        let pattern = "([0-9]+\\s)"
        let replace = "</div><div id='paragraph'>$1"
        definision = definision.replacingOccurrences(
                of: pattern,
                with: replace,
                options: NSString.CompareOptions.regularExpression,
                range: nil)
        definision = definision + "</p>"
       
        body = "<span id='word'>" + word.removeInt() + "</span>"
             + "<span id='pronunce'>" + pronunce + "</span>"
             + "<br>"
             + etymology
             + definision
        
        var css: [String] = []
        css.append("body {font-size:12px;font-family:sans-serif;}")
        css.append("#word {font-size:14px;font-weight:bold;}")
        css.append("#pronunce {font-size:10px;color:#6E6E6E;}")
        css.append("#paragraph {text-indent:-10px;margin-left:10px;}")
        
        let html = "<html>"
                +    "<head>"
                +      "<style type=\"text/css\">"
                +        css.joined(separator: "")
                +      "</style>"
                +    "</head>"
                +    "<body>"
                +      body
                +    "</body>"
                +  "</html>"
        
        return html
    }
}

