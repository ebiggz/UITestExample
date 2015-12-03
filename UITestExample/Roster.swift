//
//  Roster.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class Roster: NSObject {

    public var players: [Player]

    public init(players: [Player]) {
        self.players = players
    }

    public convenience override init() {
        self.init(players: [Player]())
    }
}
