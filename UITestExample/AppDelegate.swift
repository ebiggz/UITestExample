//
//  AppDelegate.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/1/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        SettingsManager.teamSettings.roster = Roster(players: [
            Player(name: "CJ Anderson"),
            Player(name: "Peyton Manning"),
            Player(name: "Demaryius Thomas"),
            Player(name: "Von Miller")
            ])

        SettingsManager.teamSettings.schedule =
            Schedule(withGames: [
                Game(againstOpponent: Opponent(withName: "Cleveland Browns"),
                    onDateString: "9/12/2015",
                    isAtHome: true, opponentScore: 10, teamScore: 21),
                Game(againstOpponent: Opponent(withName: "Oakland Raiders"),
                    onDateString: "10/3/2015",
                    isAtHome: false, opponentScore: 28, teamScore: 25),
                Game(againstOpponent: Opponent(withName: "Chicago Bears"),
                    onDateString: "12/20/2015",
                    isAtHome: false)])

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

