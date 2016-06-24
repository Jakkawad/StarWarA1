//
//  StringArrayConvertible.swift
//  StarWarA1
//
//  Created by admin on 6/22/2559 BE.
//  Copyright © 2559 All2Sale. All rights reserved.
//

import Foundation

extension String {
    func splitStringToArray() -> Array<String> {
        var outputArray = Array<String>()
        
        let components = self.componentsSeparatedByString(",")
        for component in components {
            let trimmedComponent = component.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            outputArray.append(trimmedComponent)
        }
        
        return outputArray
    }
}