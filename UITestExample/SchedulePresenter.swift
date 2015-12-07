//
//  SchedulePresenter.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class SchedulePresenter: SchedulePresenterType {
    // MARK: Properties

    private var schedule = Schedule()


    // MARK: RosterPresenterType

    public weak var delegate: SchedulePresenterDelegate?

    public var presentedGames: [Game] {
        return schedule.games
    }

    public func setSchedule(newSchedule: Schedule) {
        schedule = newSchedule

        schedule.games.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        delegate?.schedulePresenterDidRefreshCompleteLayout(self)
    }

    // MARK: Methods

    public func insertGame(game: Game) {
        delegate?.schedulePresenterWillChangeScheduleLayout(self)

        internalAddGame(game)

        delegate?.schedulePresenterDidChangeScheduleLayout(self)
    }

    public func insertGames(games: [Game]) {
        if games.isEmpty { return }

        delegate?.schedulePresenterWillChangeScheduleLayout(self)

        for game in games {
            internalAddGame(game)
        }

        delegate?.schedulePresenterDidChangeScheduleLayout(self)
    }

    public func removeGame(game: Game) {
        let gameIndex = presentedGames.indexOf(game)

        if gameIndex == nil {
            preconditionFailure("A game was requested to be removed that isn't in the schedule.")
        }

        delegate?.schedulePresenterWillChangeScheduleLayout(self)

        schedule.games.removeAtIndex(gameIndex!)

        delegate?.schedulePresenter(self, didRemoveGame: game, atIndex: gameIndex!)

        delegate?.schedulePresenterDidChangeScheduleLayout(self)
    }

    public func removeGames(games: [Game]) {
        if games.isEmpty { return }

        delegate?.schedulePresenterWillChangeScheduleLayout(self)

        for game in games {
            if let gameIndex = presentedGames.indexOf(game) {
                schedule.games.removeAtIndex(gameIndex)

                delegate?.schedulePresenter(self, didRemoveGame: game, atIndex: gameIndex)

            }
            else {
                preconditionFailure("A game was requested to be removed that isn't in the schedule.")
            }
        }

        delegate?.schedulePresenterDidChangeScheduleLayout(self)
    }

    public func updateGame(game: Game) {
        precondition(presentedGames.contains(game), "A game can only be updated if it already exists in the schedule.")

        let index = presentedGames.indexOf(game)!

        delegate?.schedulePresenterWillChangeScheduleLayout(self)

        delegate?.schedulePresenter(self, didUpdateGame: game, atIndex: index)

        schedule.games.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        let newIndex = schedule.games.indexOf(game)!

        if index != newIndex {
            delegate?.schedulePresenter(self, didMoveGame: game, fromIndex: index, toIndex: newIndex)
        }

        delegate?.schedulePresenterDidChangeScheduleLayout(self)

    }

    public func moveGame(game: Game, toIndex: Int) {

        delegate?.schedulePresenterWillChangeScheduleLayout(self)

        internalMoveGame(game, toIndex: toIndex)

        delegate?.schedulePresenterDidChangeScheduleLayout(self)
    }

    public func gamesAtIndexes(indexes: NSIndexSet) -> [Game] {
        var games = [Game]()

        games.reserveCapacity(indexes.count)

        for idx in indexes {
            games += [self.presentedGames[idx]]
        }

        return games
    }


    // MARK: Internal Updating Methods

    private func internalAddGame(game: Game) {
        precondition(!presentedGames.contains(game), "A game was requested to be added that is already in the schedule.")

        schedule.games.insert(game, atIndex: 0)

        schedule.games.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        delegate?.schedulePresenter(self, didAddGame: game, atIndex: schedule.games.indexOf(game)!)
    }

    private func internalMoveGame(game: Game, toIndex: Int) -> Int {
        precondition(presentedGames.contains(game), "A game can only be moved if it already exists in the schedule.")
        
        let fromIndex = presentedGames.indexOf(game)!
        
        
        schedule.games.removeAtIndex(fromIndex)
        schedule.games.insert(game, atIndex: toIndex)
        
        delegate?.schedulePresenter(self, didMoveGame: game, fromIndex: fromIndex, toIndex: toIndex)
        
        return fromIndex
    }

}
