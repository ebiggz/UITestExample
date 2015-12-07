//
//  NewGameViewController.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/4/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var opponentNameField: UITextField!
    @IBOutlet weak var gameCompletedSwitch: UISwitch!
    @IBOutlet weak var teamScoreField: UITextField!
    @IBOutlet weak var opponentScoreField: UITextField!
    @IBOutlet weak var teamScoreStepper: UIStepper!
    @IBOutlet weak var opponentScoreStepper: UIStepper!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var gameLocationSelector: UISegmentedControl!
    @IBOutlet weak var scoresSection: UIStackView!
    @IBOutlet weak var headerLabel: UILabel!

    var isNewGame = true
    var wrapper = GameWrapper()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        opponentNameField.delegate = self
        teamScoreField.delegate = self
        opponentScoreField.delegate = self

        datePicker.minimumDate = NSDate()

        if(!wrapper.isNew) {
            populateOptions()
        }

        setAccessibilityIdentifiers()
    }

    func populateOptions() {
        headerLabel.text = "Edit Game"
        let game = wrapper.game
            opponentNameField.text = game.opponent.name
            if(game.isOver) {
                gameCompletedSwitch.setOn(true, animated: true)
                scoresSection.hidden = false
                scoresSection.alpha = 1
                teamScoreField.text = String(game.teamScore)
                teamScoreStepper.value = Double(game.teamScore)
                opponentScoreField.text = String(game.opponentScore)
                opponentScoreStepper.value = Double(game.opponentScore)
                datePicker.maximumDate = NSDate()
                datePicker.minimumDate = nil
            }
            datePicker.date = game.date
            gameLocationSelector.selectedSegmentIndex = game.atHome ? 0 : 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let scheduleView = segue.destinationViewController as? ScheduleViewController {
            scheduleView.gameWrapper = wrapper
        }
    }

    // MARK: IBActions
    @IBAction func completedStateChange(sender: UISwitch) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scoresSection.hidden = !sender.on
            self.scoresSection.alpha = !sender.on ? 0 : 1
            self.view.endEditing(true)
        }
        if(sender.on) {
            datePicker.maximumDate = NSDate()
            datePicker.minimumDate = nil
        } else {
            datePicker.minimumDate = NSDate()
            datePicker.maximumDate = nil
        }
        datePicker.date = wrapper.game.date
    }
    
    @IBAction func saveNewGame(sender: UIBarButtonItem) {
        if(validateOptions()) {
            if(wrapper.isNew) {
                wrapper.game = Game()
            }
            wrapper.canceled = false
            wrapper.game.opponent.name = opponentNameField.text!
            wrapper.game.date = datePicker.date
            wrapper.game.opponentScore = Int(opponentScoreField.text!)!
            wrapper.game.teamScore = Int(teamScoreField.text!)!
            wrapper.game.atHome = (gameLocationSelector.selectedSegmentIndex == 0)
            self.performSegueWithIdentifier("save", sender: self)
        }
    }

    @IBAction func datePickerUpdate(sender: UIDatePicker) {
        setDatePickerAccesibilityIndentifier()
    }

    func validateOptions() -> Bool {
        if(opponentNameField.text!.isEmpty) {
            presentAlert("The opponent team must have a name!")
            return false
        }
        else if(gameCompletedSwitch.on) {
            if(Int(opponentScoreField.text!) == Int(teamScoreField.text!)) {
                presentAlert("Games cannot be a tie.")
                return false
            }
        }
        return true
    }

    @IBAction func stepperUpdate(sender: UIStepper) {
        if(sender == teamScoreStepper) {
            teamScoreField.text = String(Int(sender.value))
        } else {
            opponentScoreField.text = String(Int(sender.value))
        }
    }

    @IBAction func textFieldUpdate(sender: UITextField) {
        if(sender == teamScoreField || sender == opponentScoreField) {
            var number = 0.0
            if(sender.hasText()) {
                if(sender.text!.length > 1) {
                    if(sender.text!.startsWith("0")) {
                        sender.text = sender.text?.subString(1, length: sender.text!.length-1)
                    }
                }
                number = Double(sender.text!)!
                if(number < 0) {
                    number = 0;
                    sender.text = "0"
                }
                else if(number > 200) {
                    number = 200
                    sender.text = "200"
                }
            } else {
                sender.text = "0"
            }
            if(sender == teamScoreField) {
                teamScoreStepper.value = number
            } else {
                opponentScoreStepper.value = number
            }
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == teamScoreField || textField == opponentScoreField) {
            if(string.characters.count < 1) {return true}
            let nonNumberSet = NSCharacterSet.decimalDigitCharacterSet().invertedSet

            var text = NSString(string: string)
            text = text.stringByTrimmingCharactersInSet(nonNumberSet)

            if(text.length > 0) {
                return true
            } else {
                return false
            }
        } else {
            return true;
        }

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: Convienience
    
    func presentAlert(message:String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func setAccessibilityIdentifiers() {
        teamScoreStepper.accessibilityIdentifier = "Team Score Stepper"
        opponentScoreStepper.accessibilityIdentifier = "Opponenet Score Stepper"
        gameLocationSelector.accessibilityIdentifier = "Location Selector"
        setDatePickerAccesibilityIndentifier()
    }

    private func setDatePickerAccesibilityIndentifier() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.stringFromDate(datePicker.date)
        datePicker.accessibilityIdentifier = "Game Date " + year
    }
}
