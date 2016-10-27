//
//  SequenceType+.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/04.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

extension Sequence {
    func firstElement() -> Self.Iterator.Element? {
        for element in self {
            return element
        }
        return nil
    }
}
