//
//  SearchWordModel.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/21.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

protocol SearchWordModelDelegate {
    func renderLookUpResult()
}

class SearchWordModel {
    var delegate: SearchWordModelDelegate!
    
    private(set) var lookupResult: String = "" {
        didSet { self.delegate.renderLookUpResult() }
    }
    
    func lookup(word: String) {
        // TODO : 辞書設定
        let wisdomPath = "/Library/Dictionaries/Sanseido The WISDOM English-Japanese Japanese-English Dictionary.dictionary"
        
        if let result = DictionaryServiceManager().lookUp(word, inDictionary: wisdomPath) {
            self.lookupResult = DictionaryServiceManager().parseResultToHTML(result)
        } else {
            self.lookupResult = "No result"
        }
    }
}