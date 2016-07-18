//
//  SequenceType+.swift
//  flush-card
//
//  Created by tasuku tozawa on 2016/07/04.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

extension SequenceType {
    func firstElement() -> Self.Generator.Element? {
        for element in self {
            return element
        }
        return nil
    }
}