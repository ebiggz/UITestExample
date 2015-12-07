//
//  SchedulePresenterDelegage.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation

public protocol SchedulePresenterDelegate: class {

    func schedulePresenterDidRefreshCompleteLayout(schedulePresenter: SchedulePresenterType)

    func schedulePresenterWillChangeScheduleLayout(schedulePresenter: SchedulePresenterType)

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didAddGame game: Game, atIndex index: Int)

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didRemoveGame game: Game, atIndex index: Int)

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didUpdateGame game: Game, atIndex index: Int)

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didMoveGame game: Game, fromIndex: Int, toIndex: Int)

    func schedulePresenterDidChangeScheduleLayout(schedulePresenter: SchedulePresenterType)
    
}