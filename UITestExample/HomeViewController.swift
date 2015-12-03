//
//  FirstViewController.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/1/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = SettingsManager.teamSettings.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        navigationItem.title = SettingsManager.teamSettings.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

