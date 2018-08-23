//
//  Extension.swift
//  ARGame
//
//  Created by punyawee  on 23/8/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import Foundation


extension Float {
    static func random() -> Float {
        return Float(Float(arc4random()) / 0xFFFFFFFF)
    }
    static func random(min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}
