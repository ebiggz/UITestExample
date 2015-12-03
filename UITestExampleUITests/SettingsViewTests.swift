//
//  SettingsViewTests.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import XCTest

class SettingsViewTests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false

        app.launch()

        UITestHelper.navigateToView(.Settings)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRenameTeam() {

        let nameField = app.tables.cells.textFields["Team Name Field"]

        nameField.clearAndTypeText("Denver Broncos")
        app.typeText("\n")
        UITestHelper.navigateToView(.Home)

        XCTAssert(app.navigationBars["Denver Broncos"].exists)
    }

    func testUpdateTeamSkill() {

        let slider = app.tables.cells.sliders.element

        //This isnt working for some reason
        slider.adjustToNormalizedSliderPosition(0.9)
    }

    func testPickPreferredDefence() {
        
        let defencePicker = app.pickerWheels.elementBoundByIndex(1)
        let defenceLabel = app.staticTexts["Selected Defence Display"]

        defencePicker.adjustToPickerWheelValue("Nickel")

        XCTAssertEqual(defenceLabel.label, "Nickel")
    }

    func testPickPreferredOffence() {

        let offencePicker = app.pickerWheels.elementBoundByIndex(0)
        let offenceLabel = app.staticTexts["Selected Offence Display"]

        offencePicker.adjustToPickerWheelValue("IFormation")

        XCTAssertEqual(offenceLabel.label, "IFormation")
    }
}
