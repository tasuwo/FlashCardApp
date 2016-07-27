//
//  String+removeInt.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/27.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

extension String {
    func removeInt() -> String {
        var result: String = ""
        for char: Character in self.characters {
            guard Int(String(char)) != nil else {
                result.append(char)
                continue
            }
        }
        return result
    }
}
