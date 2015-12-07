//
//  ScheduleViewTests.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/4/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import XCTest

class ScheduleViewTests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app.terminate()
    }

    func testAddNewFutureGame() {

        let game = GameTest()
        let date = 7.days.fromNow.setMinutes(30)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd"
        let gameCell = app.tables.cells["Atlanta Falcons"]

        game.opponent = "Atlanta Falcons"
        game.date = date
        game.save()

        XCTAssert(gameCell.exists)
        XCTAssertEqual(gameCell.staticTexts["Location"].label, "vs")
        XCTAssertEqual(gameCell.staticTexts["Opponent Name"].label, "Atlanta Falcons")
        XCTAssertEqual(gameCell.staticTexts["Game Date"].label, formatter.stringFromDate(date))

    }

    func testAddNewPastGame() {

        let game = GameTest()
        let date = 7.days.ago.setMinutes(30)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd"
        let gameCell = app.tables.cells["Atlanta Falcons"]

        game.opponent = "Atlanta Falcons"
        game.completed = true
        game.teamScore = 30
        game.opponentScore = 14
        game.date = date
        game.save()

        //print(gameCell.staticTexts.debugDescription)
        
        XCTAssert(gameCell.exists)
        XCTAssertEqual(gameCell.staticTexts["Location"].label, "vs")
        XCTAssertEqual(gameCell.staticTexts["Opponent Name"].label, "Atlanta Falcons")
        XCTAssertEqual(gameCell.staticTexts["Game Date"].label, formatter.stringFromDate(date))
        XCTAssertEqual(gameCell.staticTexts["WinLoss"].label, "W")
        XCTAssertEqual(gameCell.staticTexts["Team Score"].label, "30")
        XCTAssertEqual(gameCell.staticTexts["Opponent Score"].label, "14")
    }
}
