//
//  DateHelper.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/5/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation


func ==(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

func <(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.compare(rhs) == .OrderedAscending
}

func >(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.compare(rhs) == .OrderedDescending
}

func +(lhs: NSDate, rhs: NSDateComponents) -> NSDate
{
    return NSCalendar.currentCalendar().dateByAddingComponents(rhs,
        toDate: lhs,
        options: [])!
}

func +(lhs: NSDateComponents, rhs: NSDate) -> NSDate
{
    return rhs + lhs
}

func -(lhs: NSDate, rhs: NSDateComponents) -> NSDate
{
    return lhs + (-rhs)
}

func combineComponents(lhs: NSDateComponents,
    rhs: NSDateComponents,
    _ multiplier: Int = 1)
    -> NSDateComponents
{
    let result = NSDateComponents()
    let undefined = Int(NSDateComponentUndefined)

    result.second = ((lhs.second != undefined ? lhs.second : 0) +
        (rhs.second != undefined ? rhs.second : 0) * multiplier)
    result.minute = ((lhs.minute != undefined ? lhs.minute : 0) +
        (rhs.minute != undefined ? rhs.minute : 0) * multiplier)
    result.hour = ((lhs.hour != undefined ? lhs.hour : 0) +
        (rhs.hour != undefined ? rhs.hour : 0) * multiplier)
    result.day = ((lhs.day != undefined ? lhs.day : 0) +
        (rhs.day != undefined ? rhs.day : 0) * multiplier)
    result.month = ((lhs.month != undefined ? lhs.month : 0) +
        (rhs.month != undefined ? rhs.month : 0) * multiplier)
    result.year = ((lhs.year != undefined ? lhs.year : 0) +
        (rhs.year != undefined ? rhs.year : 0) * multiplier)
    return result
}

// With combineComponents defined,
// overloading + and - is simple

func +(lhs: NSDateComponents, rhs: NSDateComponents) -> NSDateComponents
{
    return combineComponents(lhs, rhs: rhs)
}

func -(lhs: NSDateComponents, rhs: NSDateComponents) -> NSDateComponents
{
    return combineComponents(lhs, rhs: rhs, -1)
}

// We'll need to overload unary - so we can negate components
prefix func -(components: NSDateComponents) -> NSDateComponents {
    let result = NSDateComponents()
    let undefined = Int(NSDateComponentUndefined)

    if(components.second != undefined) { result.second = -components.second }
    if(components.minute != undefined) { result.minute = -components.minute }
    if(components.hour != undefined) { result.hour = -components.hour }
    if(components.day != undefined) { result.day = -components.day }
    if(components.month != undefined) { result.month = -components.month }
    if(components.year != undefined) { result.year = -components.year }
    return result
}

extension Int {

    var seconds: NSDateComponents {
        let components = NSDateComponents()
        components.second = self;
        return components
    }

    var second: NSDateComponents {
        return self.seconds
    }

    var minutes: NSDateComponents {
        let components = NSDateComponents()
        components.minute = self;
        return components
    }

    var minute: NSDateComponents {
        return self.minutes
    }

    var hours: NSDateComponents {
        let components = NSDateComponents()
        components.hour = self;
        return components
    }

    var hour: NSDateComponents {
        return self.hours
    }

    var days: NSDateComponents {
        let components = NSDateComponents()
        components.day = self;
        return components
    }

    var day: NSDateComponents {
        return self.days
    }

    var weeks: NSDateComponents {
        let components = NSDateComponents()
        components.day = 7 * self;
        return components
    }

    var week: NSDateComponents {
        return self.weeks
    }

    var months: NSDateComponents {
        let components = NSDateComponents()
        components.month = self;
        return components
    }

    var month: NSDateComponents {
        return self.months
    }

    var years: NSDateComponents {
        let components = NSDateComponents()
        components.year = self;
        return components
    }
    
    var year: NSDateComponents {
        return self.years
    }
    
}

extension NSDateComponents {

    var fromNow: NSDate {
        let currentCalendar = NSCalendar.currentCalendar()
        return currentCalendar.dateByAddingComponents(self,
            toDate: NSDate(),
            options: [])!
    }

    var ago: NSDate {
        let currentCalendar = NSCalendar.currentCalendar()
        return currentCalendar.dateByAddingComponents(-self,
            toDate: NSDate(),
            options: [])!
    }
}

extension NSDate {
    func setMinutes(minutes: Int) -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!

        let components = cal.components([.Day , .Month, .Year, .Hour], fromDate: self)
        components.minute = minutes

        return cal.dateFromComponents(components)!
    }

    func setHour(hour: Int) -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!

        let components = cal.components([.Day , .Month, .Year, .Minute], fromDate: self)
        components.hour = hour

        return cal.dateFromComponents(components)!
    }

}
