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
        }
    }
}

public enum AppView {
    case Settings
    case Home
    case Roster
    case Schedule
}

extension XCUIElement {
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
}