//
//  FullRosterPresenter.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class FullRosterPresenter: NSObject, RosterPresenterType {

    // MARK: Properties
    
    private var roster = Roster()


    // MARK: RosterPresenterType

    public weak var delegate: RosterPresenterDelegate?

    public var presentedPlayers: [Player] {
        return roster.players
    }

    public func setRoster(newRoster: Roster) {

            roster = newRoster

            delegate?.rosterPresenterDidRefreshCompleteLayout(self)
    }

    // MARK: Methods

    public func insertPlayer(player: Player) {
        delegate?.rosterPresenterWillChangeRosterLayout(self)

        unsafeAddPlayer(player)

        delegate?.rosterPresenterDidChangeRosterLayout(self)
    }

    public func insertPlayers(players: [Player]) {
        if players.isEmpty { return }

        delegate?.rosterPresenterWillChangeRosterLayout(self)

        for player in players {
            unsafeAddPlayer(player)
        }

        delegate?.rosterPresenterDidChangeRosterLayout(self)
    }

    public func removePlayer(player: Player) {
        let playerIndex = presentedPlayers.indexOf(player)

        if playerIndex == nil {
            preconditionFailure("A player was requested to be removed that isn't in the roster.")
        }

        delegate?.rosterPresenterWillChangeRosterLayout(self)

        roster.players.removeAtIndex(playerIndex!)

        delegate?.rosterPresenter(self, didRemovePlayer: player, atIndex: playerIndex!)

        delegate?.rosterPresenterDidChangeRosterLayout(self)
    }

    public func removePlayers(players: [Player]) {
        if players.isEmpty { return }

        delegate?.rosterPresenterWillChangeRosterLayout(self)

        for player in players {
            if let playerIndex = presentedPlayers.indexOf(player) {
                roster.players.removeAtIndex(playerIndex)

                delegate?.rosterPresenter(self, didRemovePlayer: player, atIndex: playerIndex)

            }
            else {
                preconditionFailure("A player was requested to be removed that isn't in the roster.")
            }
        }

        delegate?.rosterPresenterDidChangeRosterLayout(self)
    }

    public func updatePlayer(player: Player, withName newName: String) {
        precondition(presentedPlayers.contains(player), "A player can only be updated if it already exists in the roster.")

        // If the text is the same, it's a no op.
        if player.name == newName { return }

        let index = presentedPlayers.indexOf(player)!

        delegate?.rosterPresenterWillChangeRosterLayout(self)

        player.name = newName

        delegate?.rosterPresenter(self, didUpdatePlayer: player, atIndex: index)

        delegate?.rosterPresenterDidChangeRosterLayout(self)

    }

    public func movePlayer(player: Player, toIndex: Int) {

        delegate?.rosterPresenterWillChangeRosterLayout(self)

        unsafeMovePlayer(player, toIndex: toIndex)

        delegate?.rosterPresenterDidChangeRosterLayout(self)
    }

    public func playersAtIndexes(indexes: NSIndexSet) -> [Player] {
        var players = [Player]()

        players.reserveCapacity(indexes.count)

        for idx in indexes {
            players += [self.presentedPlayers[idx]]
        }

        return players
    }


    // MARK: Internal Unsafe Updating Methods

    private func unsafeAddPlayer(player: Player) {
        precondition(!presentedPlayers.contains(player), "A player was requested to be added that is already in the roster.")

        roster.players.insert(player, atIndex: 0)

        print("inserted " + player.name)

        delegate?.rosterPresenter(self, didAddPlayer: player, atIndex: 0)
    }

    private func unsafeMovePlayer(player: Player, toIndex: Int) -> Int {
        precondition(presentedPlayers.contains(player), "A list item can only be moved if it already exists in the presented list items.")

        let fromIndex = presentedPlayers.indexOf(player)!


        roster.players.removeAtIndex(fromIndex)
        roster.players.insert(player, atIndex: toIndex)

        delegate?.rosterPresenter(self, didMovePlayer: player, fromIndex: fromIndex, toIndex: toIndex)

        return fromIndex
    }
}
