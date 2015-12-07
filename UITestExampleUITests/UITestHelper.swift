//
//  AppTestHelper.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import XCTest

public class UITestHelper {
    public static func navigateToView(view: AppView) {
        let app = XCUIApplication()
        switch(view) {
        case .Settings:
            app.tabBars.buttons["Settings"].tap()
        case .Home:
            app.tabBars.buttons["Home"].tap()
        case .Roster:
            app.tabBars.buttons["Home"].tap()
            app.tables.cells.elementBoundByIndex(1).tap()
        case .Schedule:
            app.tabBars.buttons["Home"].tap()
            app.tables.cells.elementBoundByIndex(0).tap()
        case .NewGame:
            app.tabBars.buttons["Home"].tap()
            app.tables.cells.elementBoundByIndex(0).tap()
        }
    }
}

public enum AppView {
    case Settings
    case Home
    case Roster
    case Schedule
    case NewGame
}

extension XCUIElement {
    //Extension for convienent text deletion as there is no built in way to do so
    func clearAndTypeText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and type text into a non string value")
            return
        }

        self.tap()

        var deleteString: String = ""
        for _ in stringValue.characters {
            deleteString += "\u{8}"
        }
        self.typeText(deleteString + text)
    }

    func adjustToDatePickerValue(withDate dateString: String, andHour hour:String, andMinutes minutes: String, andPeriod period: String) {
        let wheels = self.pickerWheels

        wheels.elementBoundByIndex(0).adjustToPickerWheelValue(dateString)
        wheels.elementBoundByIndex(1).adjustToPickerWheelValue(hour)
        wheels.elementBoundByIndex(2).adjustToPickerWheelValue(minutes)
        wheels.elementBoundByIndex(3).adjustToPickerWheelValue(period)
    }

    func adjustToDatePickerValue(withDate date: NSDate) {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d/h/mm/a"

        let dateArray = dateFormatter.stringFromDate(date).componentsSeparatedByString("/")

        self.adjustToDatePickerValue(withDate: dateArray[0], andHour: dateArray[1], andMinutes: dateArray[2], andPeriod: dateArray[3])
    }
}