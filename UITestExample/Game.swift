//
//  Game.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public class Game: NSObject {

    var opponent: Opponent
    var opponentScore: Int
    var teamScore: Int
    var date: NSDate
    var atHome: Bool
    var uuid: NSUUID


    private init(againstOpponent opponent: Opponent, onDate date: NSDate, isAtHome atHome: Bool, opponentScore: Int, teamScore: Int, withUUID uuid: NSUUID) {
        self.opponent = opponent
        self.date = date
        self.atHome = atHome
        self.opponentScore = opponentScore
        self.teamScore = teamScore
        self.uuid = uuid
    }

    public convenience init(againstOpponent opponent: Opponent, onDate date: NSDate, isAtHome atHome: Bool, opponentScore: Int, teamScore: Int) {
        self.init(againstOpponent: opponent, onDate: date, isAtHome: atHome, opponentScore: opponentScore, teamScore: teamScore, withUUID: NSUUID())
    }

    public convenience init(againstOpponent opponent: Opponent, onDateString dateString: String, isAtHome atHome: Bool, opponentScore: Int, teamScore: Int) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()

        self.init(againstOpponent: opponent, onDate: dateFormatter.dateFromString(dateString)!, isAtHome: atHome, opponentScore: opponentScore, teamScore: teamScore)
    }

    public convenience init(againstOpponent opponent: Opponent, onDate date: NSDate, isAtHome atHome: Bool) {
        self.init(againstOpponent: opponent, onDate: date, isAtHome: atHome, opponentScore: 0, teamScore: 0)
    }

    public convenience init(againstOpponent opponent: Opponent, onDateString dateString: String, isAtHome atHome: Bool) {
        self.init(againstOpponent: opponent, onDateString: dateString, isAtHome: atHome, opponentScore: 0, teamScore: 0)
    }

    public convenience override init() {
        self.init(againstOpponent: Opponent(), onDate: NSDate(), isAtHome: true, opponentScore: 0, teamScore: 0)
    }


    var isOver: Bool {
        let compareResult = date.compare(NSDate())
        if compareResult == NSComparisonResult.OrderedDescending {
            return false;
        }
        return true
    }

    var finalScoreDescription: String {
        var scores = teamScore > opponentScore ? "W" : "L"
        scores += " " + String(teamScore) + " - " + String(opponentScore)
        return scores
    }

    var teamWon: Bool {
        return teamScore > opponentScore
    }

    var dateDescription: String {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()

        return dateFormatter.stringFromDate(date)
    }

    // MARK: Equality

    override public func isEqual(object: AnyObject?) -> Bool {
        if let game = object as? Game {
            return uuid == game.uuid
        }
        return false
    }
}
