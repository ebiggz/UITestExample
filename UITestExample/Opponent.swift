//
//  Opponent.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class Opponent: NSObject {

    var name: String
    var skill: Int

    public init(withName name: String, andSkill skill: Int) {
        self.name = name
        self.skill = skill
    }

    public convenience init(withName name: String) {
        self.init(withName: name, andSkill: 5)
    }

    public convenience override init() {
        self.init(withName: "", andSkill: 5)
    }

}