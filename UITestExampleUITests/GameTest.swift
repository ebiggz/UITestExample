//
//  GameTest.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/6/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import XCTest


public class GameTest: NSObject {

    private(set) var gameIsCompleted = false
    private(set) var isNewGame = true
    private var gameToEditIndex = -1
    private let app = XCUIApplication()
    private var didSaveOrCancel = false


    init(gameToEditIndex: Int = -1) {
        super.init()
        if(gameToEditIndex > -1) {
            isNewGame = false
            self.gameToEditIndex = gameToEditIndex
        }
        navigateToGameView()
    }

    private func navigateToGameView() {
        UITestHelper.navigateToView(.Schedule)
        if(isNewGame) {
            app.navigationBars["Schedule"].buttons["Add"].tap()
        } else {
            app.tables.cells.elementBoundByIndex(UInt(gameToEditIndex)).tap()
        }
    }

    var opponent: String {
        set(name) {
            if(didSaveOrCancel) {return}
            let opponentField = getElement(.OpponentField)
            opponentField.tap()
            opponentField.clearAndTypeText(name)
            pressReturn()
        }
        get {
            let opponentField = getElement(.OpponentField)
            return opponentField.value as! String
        }
    }

    var completed: Bool {
        set(shouldComplete) {
            if(didSaveOrCancel) {return}
            let completedSwitch = getElement(.CompletedSwitch)
            if(shouldComplete) {
                if(!self.completed) {
                    completedSwitch.tap()
                }
            } else {
                if(self.completed) {
                    completedSwitch.tap()
                }
            }
        }
        get {
            return (getElement(.CompletedSwitch).value as! NSString).boolValue
        }
    }

    var teamScore: Int {
        set(newScore) {
            if(didSaveOrCancel) {return}
            let teamScoreField = getElement(.TeamScoreField)
            teamScoreField.tap()
            teamScoreField.clearAndTypeText(String(newScore))
            pressReturn()
        }
        get {
            let teamScoreField = getElement(.TeamScoreField)
            return Int(teamScoreField.value as! String)!
        }
    }

    var opponentScore: Int {
        set(newScore) {
            if(didSaveOrCancel) {return}
            let opponentScoreField = getElement(.OpponentScoreField)
            opponentScoreField.tap()
            opponentScoreField.clearAndTypeText(String(newScore))
            pressReturn()
        }
        get {
            let opponentScoreField = getElement(.OpponentScoreField)
            return Int(opponentScoreField.value as! String)!
        }
    }

    var date: NSDate {
        set(newDate) {
            if(didSaveOrCancel) {return}
            let datePicker = getElement(.DatePicker)
            datePicker.adjustToDatePickerValue(withDate: newDate)
        }
        get {
            let datePicker = getElement(.DatePicker)
            let datePickerWheels = datePicker.pickerWheels

            let date = datePickerWheels.elementBoundByIndex(0).value as! String
            let hour = datePickerWheels.elementBoundByIndex(1).value as! String
            let minutes = datePickerWheels.elementBoundByIndex(2).value as! String
            let period = datePickerWheels.elementBoundByIndex(3).value as! String

            var fullDate = date + " " + datePicker.identifier.stringByReplacingOccurrencesOfString("Game Date ", withString: "") + " " + hour + " " + minutes + " " + period
            print(fullDate)

            fullDate = fullDate.stringByReplacingOccurrencesOfString("minutes ", withString: "")
            fullDate = fullDate.stringByReplacingOccurrencesOfString(",", withString: "")
            fullDate = fullDate.stringByReplacingOccurrencesOfString("o'clock ", withString: ":")

            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d yyyy h:mm a"

            return formatter.dateFromString(fullDate)!
        }
    }

    var location: GameLocation {
        set(newLocation) {
            if(didSaveOrCancel) {return}
            let locSelector = getElement(.LocationSelector)
            if(newLocation == .Away) {
                locSelector.buttons["Away"].tap()
            } else {
                locSelector.buttons["Home"].tap()
            }
        }
        get {
            let locSelector = getElement(.LocationSelector)
            if (locSelector.buttons["Home"].selected) {
                return .Home
            } else {
                return .Away
            }
        }
    }

    public func updateScoreWithStepper(scoreType: ScoreType, changeAmount: Int) {
        if(didSaveOrCancel) {return}
        if changeAmount < 0 {
            for _ in changeAmount...(-1) {
                if(scoreType == .Team) {
                    getElement(.TeamScoreStepper).buttons["Decrement"].tap()
                } else {
                    getElement(.OpponentScoreStepper).buttons["Decrement"].tap()
                }
            }
        } else {
            for _ in 1...changeAmount {
                if(scoreType == .Team) {
                    getElement(.TeamScoreStepper).buttons["Increment"].tap()
                } else {
                    getElement(.OpponentScoreStepper).buttons["Increment"].tap()
                }
            }
        }
    }

    public func save() {
        if(didSaveOrCancel) {return}
        didSaveOrCancel = true
        app.toolbars.buttons["Save"].tap()
    }

    public func cancel() {
        if(didSaveOrCancel) {return}
        didSaveOrCancel = true
        app.toolbars.buttons["Cancel"].tap()
    }

    //MARK: Convenience

    private func pressReturn() {
        app.typeText("\n")
    }

    func getElement(elementType: GameUIElement) -> XCUIElement {
        switch(elementType) {
        case .OpponentField:
            return app.textFields["Opponent Name"]
        case .CompletedSwitch:
            return app.switches["Completed Switch"]
        case .OpponentScoreField:
            return app.textFields["Opponent Score Field"]
        case .OpponentScoreStepper:
            return app.steppers["Opponent Score Stepper"]
        case .TeamScoreStepper:
            return app.steppers["Team Score Stepper"]
        case .TeamScoreField:
            return app.textFields["Team Score Field"]
        case .DatePicker:
            //let predicate = NSPredicate(format: "label BEGINSWITH 'Game Date'")
            //return app.datePickers.elementMatchingPredicate(predicate)
            return app.datePickers.element
        case .LocationSelector:
            return app.segmentedControls["Location Selector"]
        }
    }

    enum GameUIElement {
        case OpponentField
        case CompletedSwitch
        case OpponentScoreField
        case OpponentScoreStepper
        case TeamScoreField
        case TeamScoreStepper
        case DatePicker
        case LocationSelector
    }

    enum GameLocation {
        case Home
        case Away
    }

    public enum ScoreType {
        case Team
        case Opponent
    }

}
