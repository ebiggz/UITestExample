//
//  UITestExampleUITests.swift
//  UITestExampleUITests
//
//  Created by Erik Bigler on 12/1/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import XCTest

class RosterViewTests: XCTestCase {

    let app = XCUIApplication()

    //set up is called before every method invocation in this class
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app.launch()

        UITestHelper.navigateToView(.Roster)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddNewPlayerToRoster() {

        let tablesQuery = app.tables
        let addPlayer = tablesQuery.textFields["Add Player"]
        let oldCount = tablesQuery.cells.count

        addPlayer.tap()
        addPlayer.typeText("Demarcus Ware")
        app.buttons["Return"].tap()

        XCTAssertEqual(tablesQuery.cells.count, oldCount + 1)
        XCTAssert(tablesQuery.textFields["Demarcus Ware"].exists)
    }

    func testRemovePlayerFromRoster() {

        let tablesQuery = app.tables
        let oldCount = tablesQuery.cells.count
        let rosterNavigationBar = app.navigationBars["Roster"]
        let peytonManning = tablesQuery.textFields["Peyton Manning"]

        rosterNavigationBar.buttons["Edit"].tap()
        tablesQuery.buttons["Delete Peyton Manning"].tap()
        tablesQuery.buttons["Delete"].tap()
        rosterNavigationBar.buttons["Done"].tap()

        XCTAssert(!peytonManning.exists)
        XCTAssertEqual(tablesQuery.cells.count, oldCount - 1)
    }

    func testRenamePlayerInRoster() {

        let tablesQuery = app.tables
        let player = tablesQuery.textFields["CJ Anderson"]

        player.clearAndTypeText("Ronnie Hillman")
        app.buttons["Return"].tap()

        XCTAssert(tablesQuery.textFields["Ronnie Hillman"].exists)
        XCTAssert(!tablesQuery.textFields["CJ Anderson"].exists)
    }

    func testReorderPlayerInRoster() {

        let tablesQuery = app.tables
        let rosterNavigationBar = app.navigationBars["Roster"]
        let playerCJ = tablesQuery.buttons["Reorder CJ Anderson"]
        let playerVon = tablesQuery.buttons["Reorder Von Miller"]

        rosterNavigationBar.buttons["Edit"].tap()
        playerCJ.pressForDuration(0.5, thenDragToElement: playerVon)
        rosterNavigationBar.buttons["Done"]

        XCTAssertEqual(tablesQuery.cells.elementBoundByIndex(3).identifier, "CJ Anderson")
    }
}

