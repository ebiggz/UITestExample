//
//  RosterPresenter.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation

public protocol RosterPresenterType: class {

    weak var delegate: RosterPresenterDelegate? { get set }

    func setRoster(newRoster: Roster)

    var presentedPlayers: [Player] { get }

    var count: Int { get }

    var isEmpty: Bool { get }
}

public extension RosterPresenterType {
    var isEmpty: Bool {
        return presentedPlayers.isEmpty
    }

    var count: Int {
        return presentedPlayers.count
    }
}