//
//  String+componentsSeparate.swift
//  FlashCard
//
//  Created by tasuku tozawa on 2016/07/27.
//  Copyright © 2016年 tasuwo. All rights reserved.
//

import Foundation

extension String {
    func componentsSeparatedByAfterString(_ string: String) -> [String] {
        var parts = self.components(separatedBy: string)
        if parts.count == 1 { return [self] }
        
        for i in 0...parts.count-2 {
            parts[i] = parts[i] as String + string
        }
        return parts
    }
    
    func componentsSeparatedByBeforeString(_ string: String) -> [String] {
        var parts = self.components(separatedBy: string)
        if parts.count == 1 { return [self] }
        
        for i in 1...parts.count-1 {
            parts[i] = string + parts[i] as String
        }
        return parts       
    }
    
    func componentsSeparatedByAfterStringAt(_ string: String, num: Int) -> [String] {
        var parts = self.componentsSeparatedByAfterString(string)
        if parts.count == 1 { return [self] }
        
        Swift.print(parts.count)
        if parts.count <= num { return [self] }
        
        let pre = parts[0...num-1]
        let bak = parts[num...parts.count-1]
        let p = pre.joined(separator: "")
        let b = bak.joined(separator: "")
        
        return [p, b]
    }
    
    func componentsSeparatedByBeforeStringAt(_ string: String, num: Int) -> [String] {
        var parts = self.componentsSeparatedByBeforeString(string)
        if parts.count == 1 { return [self] }
        
        if parts.count <= num { return [self] }
        
        let pre = parts[0...num-1]
        let bak = parts[num...parts.count-1]
        let p = pre.joined(separator: "")
        let b = bak.joined(separator: "")
        
        return [p, b]       
    }
}

