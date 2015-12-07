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
        app.terminate()
    }

    func testRenameTeam() {

        let nameField = app.tables.cells.textFields["Team Name Field"]

        nameField.clearAndTypeText("Denver Broncos")
        app.typeText("\n")
        UITestHelper.navigateToView(.Home)

        XCTAssert(app.navigationBars["Denver Broncos"].exists)
    }

    /* 
     * Note(Erik 12/4/15): This isn't working due to possible Apple bug. 'adjustToNormalizedSliderPosition' 
     * is non-functional. Appears to break when slider is in a TableView.
     */
    func testUpdateTeamSkill() {

        let slider = app.sliders["Skill Slider"]
        //let sliderLabel = app.staticTexts["Skill Display Label"]

        slider.adjustToNormalizedSliderPosition(0.8)

        //XCTAssertEqual(slider.normalizedSliderPosition, 0.8)
        //XCTAssertEqual(sliderLabel.label, "8")

    }

    func testPickPreferredDefense() {
        
        let defensePicker = app.pickerWheels.elementBoundByIndex(1)
        let defenseLabel = app.staticTexts["Selected Defense Display"]

        defensePicker.adjustToPickerWheelValue("Nickel")

        XCTAssertEqual(defenseLabel.label, "Nickel")
    }

    func testPickPreferredOffence() {

        let offencePicker = app.pickerWheels.elementBoundByIndex(0)
        let offenceLabel = app.staticTexts["Selected Offence Display"]

        offencePicker.adjustToPickerWheelValue("IFormation")

        XCTAssertEqual(offenceLabel.label, "IFormation")
    }
}
