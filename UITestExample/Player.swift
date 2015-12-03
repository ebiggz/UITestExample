//
//  Player.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class Player: NSObject {

    public var name: String
    private var UUID: NSUUID

    private init(name: String, UUID: NSUUID) {
        self.name = name
        self.UUID = UUID
    }

    public convenience init(name: String) {
        self.init(name: name, UUID: NSUUID())
    }

    // MARK: Equality
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let player = object as? Player {
            return UUID == player.UUID
        }
        return false
    }

}
