//
//  SecondViewController.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/1/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {


    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var skillSlider: UISlider!
    @IBOutlet weak var offencePicker: UIPickerView!
    @IBOutlet weak var defencePicker: UIPickerView!
    @IBOutlet weak var offenceLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureSettings() {

        let settings = SettingsManager.teamSettings

        teamName.text = settings.name
        teamName.delegate = self

        sliderLabel.text = String(settings.skillLevel)

        skillSlider.value = Float(settings.skillLevel)

        offencePicker.delegate = self
        offencePicker.dataSource = self
        defencePicker.dataSource = self
        defencePicker.delegate = self

        defencePicker.selectRow(settings.selectedDefenceIndex, inComponent: 0, animated: true)
        offencePicker.selectRow(settings.selectedOffenceIndex, inComponent: 0, animated: true)

        offenceLabel.text = Offence.stringValues[settings.selectedOffenceIndex]
        defenceLabel.text = Defence.stringValues[settings.selectedDefenceIndex]

    }

    @IBAction func sliderUpdate(sender: UISlider) {
        SettingsManager.teamSettings.skillLevel = Int(sender.value)
        sliderLabel.text = String(Int(sender.value))
    }

    func textFieldDidEndEditing(textField: UITextField) {

        guard let text = textField.text else { return }

        if !text.isEmpty {

            SettingsManager.teamSettings.name = text
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        // An item must have text to dismiss the keyboard.
        guard let text = textField.text where !text.isEmpty else { return false }

        textField.resignFirstResponder()
        
        return true
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == offencePicker) {
            return Offence.allValues.count
        } else {
            return Defence.allValues.count
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == offencePicker) {
            return Offence.stringValues[row]
        } else {
            return Defence.stringValues[row]
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == offencePicker) {
            offenceLabel.text = Offence.stringValues[row]
            SettingsManager.teamSettings.selectedOffenceIndex = row
        } else {
            defenceLabel.text = Defence.stringValues[row]
            SettingsManager.teamSettings.selectedDefenceIndex = row
        }
    }
}

