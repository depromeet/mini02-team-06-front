//
//  NSObject+.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 7..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import Foundation

extension NSObject {
    public static var classNameToString : String{
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
