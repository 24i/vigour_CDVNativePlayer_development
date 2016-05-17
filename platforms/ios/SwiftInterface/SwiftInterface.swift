//
//  WsiftInterface.swift
//  NativePlayer
//
//  Created by Stuart Grimshaw on 14/05/16.
//
//

import Foundation

@objc class SwiftInterface: CDVPlugin
{
    func sayHi(name: String)
    {
        print("SwiftInterface says hi \(name)")
    }
}