//
//  SchedulePresenterType.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


public protocol SchedulePresenterType: class {

    weak var delegate: SchedulePresenterDelegate? { get set }

    func setSchedule(newSchedule: Schedule)

    var presentedGames: [Game] { get }

    var count: Int { get }

    var isEmpty: Bool { get }
}


public extension SchedulePresenterType {
    var isEmpty: Bool {
        return presentedGames.isEmpty
    }

    var count: Int {
        return presentedGames.count
    }
}