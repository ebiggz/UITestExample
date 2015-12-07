//
//  Schedule.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class Schedule {

    var games: [Game]

    public init(withGames games: [Game]) {
        self.games = games
    }

    public convenience init() {
        self.init(withGames: [Game]())
    }
}
