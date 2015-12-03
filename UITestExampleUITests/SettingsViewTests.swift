//
//  SettingsViewTests.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import XCTest

class SettingsViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.

        continueAfterFailure = false

        XCUIApplication().launch()

        UITestHelper.navigateToView(.Settings)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRenameTeam() {

        let app = XCUIApplication()
        let nameField = app.tables.cells.textFields["Team Name Field"]

        nameField.clearAndTypeText("Denver Broncos")
        app.typeText("\n")

        UITestHelper.navigateToView(.Home)

        XCTAssert(app.navigationBars["Denver Broncos"].exists)

    }

    func testUpdateTeamSkill() {

        let app = XCUIApplication()
        let slider = app.tables.cells.sliders.element

        slider.adjustToNormalizedSliderPosition(0.9)

    }

}
