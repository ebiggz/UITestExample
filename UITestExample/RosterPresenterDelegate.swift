//
//  RosterPresenterDelegate.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public protocol RosterPresenterDelegate: class {

    func rosterPresenterDidRefreshCompleteLayout(rosterPresenter: RosterPresenterType)

    func rosterPresenterWillChangeRosterLayout(rosterPresenter: RosterPresenterType)

    func rosterPresenter(rosterPresenter: RosterPresenterType, didAddPlayer player: Player, atIndex index: Int)

    func rosterPresenter(rosterPresenter: RosterPresenterType, didRemovePlayer player: Player, atIndex index: Int)

    func rosterPresenter(rosterPresenter: RosterPresenterType, didUpdatePlayer player: Player, atIndex index: Int)

    func rosterPresenter(rosterPresenter: RosterPresenterType, didMovePlayer player: Player, fromIndex: Int, toIndex: Int)

    func rosterPresenterDidChangeRosterLayout(rosterPresenter: RosterPresenterType)

}