//
//  TeamSettings.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import Foundation

public class SettingsManager {
    static var teamSettings = TeamSettings()
}

struct TeamSettings {
    var name = "Test Team"
    var skillLevel = 5
    var color = Color.Blue
    var selectedDefenceIndex = 0
    var selectedOffenceIndex = 0
    var roster = Roster()
}

public enum Color {
    case Blue
    case Green
    case Yellow
    case Orange
    case Red
    case Purple

    public var name: String {
        switch self {
        case .Blue:      return "Blue"
        case .Green:     return "Green"
        case .Yellow:    return "Yellow"
        case .Orange:    return "Orange"
        case .Red:       return "Red"
        case .Purple:    return "Purple"
        }
    }
}

public enum Defence {

    case Dime
    case Nickel

    public var name: String {
        switch self {
        case .Dime:   return "Dime"
        case .Nickel: return "Nickel"
        }
    }

    public static var allValues: [Defence] {
        get {
            return [Dime,Nickel]
        }
    }

    public static var stringValues: [String] {
        var vals = [String]()
        for formation in Defence.allValues {
            vals.append(formation.name)
        }
        return vals
    }

}

public enum Offence {
    case Shotgun
    case Pistol
    case SingleBack
    case Goalline
    case IFormation

    public var name: String {
        switch self{
        case .Shotgun: return "Shotgun"
        case .Pistol: return "Pistol"
        case .SingleBack: return "SingleBack"
        case .Goalline: return "Goalline"
        case .IFormation: return "IFormation"
        }
    }

    public static var allValues: [Offence] {
        get {
            return [Shotgun,Pistol,SingleBack,Goalline,IFormation]
        }
    }

    public static var stringValues: [String] {
        var vals = [String]()
        for formation in Offence.allValues {
            vals.append(formation.name)
        }
        return vals
    }

}

