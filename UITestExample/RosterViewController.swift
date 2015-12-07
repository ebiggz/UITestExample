//
//  RosterViewController.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/2/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import UIKit

class RosterViewController: UITableViewController, RosterPresenterDelegate, UITextFieldDelegate {

    // MARK: Properties
    private var rosterPresenter = FullRosterPresenter()

    /// Set in `textFieldDidBeginEditing(_:)`. `nil` otherwise.
    weak var activeTextField: UITextField?

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        rosterPresenter.delegate = self

        rosterPresenter.setRoster(SettingsManager.teamSettings.roster)

        navigationItem.rightBarButtonItem = editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableViewDataSource

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editing {
            return rosterPresenter.count
        }
        return rosterPresenter.count + 1
    }

    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
    }

    override func tableView(_: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // The initial row is reserved for adding new players so it can't be deleted or edited.
        if !editing && indexPath.row == 0 {
            return false
        }

        return true
    }

    override func tableView(_: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // The initial row is reserved for adding new players so it can't be moved.
        if !editing && indexPath.row == 0 {
            return false
        }

        return true
    }

    override func tableView(_: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }

        let player = rosterPresenter.presentedPlayers[indexPath.row]

        rosterPresenter.removePlayer(player)
    }

    override func tableView(_: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let player = rosterPresenter.presentedPlayers[fromIndexPath.row]

        rosterPresenter.movePlayer(player, toIndex: toIndexPath.row)
    }

    // MARK: UITableViewDelegate

    override func tableView(_: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch cell {
        case let playerCell as PlayerCell:
            configurePlayerCell(playerCell, forRow: indexPath.row)

        default:
            fatalError("Attempting to configure an unknown or unsupported cell type in `ListViewController`.")
        }
    }

    override func tableView(_: UITableView, willBeginEditingRowAtIndexPath: NSIndexPath) {
        /*
        When the user swipes to show the delete confirmation, don't enter editing mode.
        `UITableViewController` enters editing mode by default so we override without calling super.
        */
    }

    override func tableView(_: UITableView, didEndEditingRowAtIndexPath: NSIndexPath) {
        /*
        When the user swipes to hide the delete confirmation, no need to exit edit mode because we didn't
        enter it. `UITableViewController` enters editing mode by default so we override without calling
        super.
        */
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(_: UITableView, targetIndexPathForMoveFromRowAtIndexPath fromIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath {

        return proposedIndexPath
    }

    // MARK: RosterPresenterDelegate

    func rosterPresenterDidRefreshCompleteLayout(rosterPresenter: RosterPresenterType) {
        tableView.reloadData()
    }

    func rosterPresenterWillChangeRosterLayout(rosterPresenter: RosterPresenterType) {
        tableView.beginUpdates()
    }

    func rosterPresenter(rosterPresenter: RosterPresenterType, didAddPlayer player: Player, atIndex index: Int) {
        let indexPathsForInsertion = [NSIndexPath(forRow: index + 1, inSection: 0)]

        tableView.insertRowsAtIndexPaths(indexPathsForInsertion, withRowAnimation: .Fade)

        if index == 0 {
            let indexPathsForReloading = [NSIndexPath(forRow: 0, inSection: 0)]
            tableView.reloadRowsAtIndexPaths(indexPathsForReloading, withRowAnimation: .Automatic)
        }

    }

    func rosterPresenter(rosterPresenter: RosterPresenterType, didRemovePlayer player: Player, atIndex index: Int) {
        let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]

        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

    }

    func rosterPresenter(rosterPresenter: RosterPresenterType, didUpdatePlayer player: Player, atIndex index: Int) {
        tableView.endUpdates()

        tableView.beginUpdates()

        var newIndex: Int
        if editing {
            newIndex = index
        } else {
            newIndex = index + 1
        }
        let indexPath = NSIndexPath(forRow: newIndex, inSection: 0)

        if let playerCell = tableView.cellForRowAtIndexPath(indexPath) as? PlayerCell {
            configurePlayerCell(playerCell, forRow: index + 1)
        }

    }

    func rosterPresenter(rosterPresenter: RosterPresenterType, didMovePlayer player: Player, fromIndex: Int, toIndex: Int) {
        let fromIndexPath = NSIndexPath(forRow: fromIndex, inSection: 0)

        let toIndexPath = NSIndexPath(forRow: toIndex, inSection: 0)

        tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }

    func rosterPresenterDidChangeRosterLayout(rosterPresenter: RosterPresenterType) {
        tableView.endUpdates()
    }

    // MARK: TextFieldDelegate

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return !editing
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(textField: UITextField) {
        defer {
            activeTextField = nil
        }

        guard let text = textField.text else { return }

        let indexPath = indexPathForView(textField)

        if indexPath != nil && indexPath!.row > 0 {
            let player = rosterPresenter.presentedPlayers[indexPath!.row - 1]

            rosterPresenter.updatePlayer(player, withName: text)
        }
        else if !text.isEmpty {
            let player = Player(name: text)

            rosterPresenter.insertPlayer(player)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let indexPath = indexPathForView(textField)!

        // The 'add player' row can always dismiss the keyboard.
        if indexPath.row == 0 {
            textField.resignFirstResponder()
            return true
        }

        // An item must have text to dismiss the keyboard.
        guard let text = textField.text where !text.isEmpty else { return false }

        textField.resignFirstResponder()
        
        return true
    }

    // MARK: UIViewController Overrides

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        // Prevent navigating back in edit mode.
        navigationItem.setHidesBackButton(editing, animated: animated)

        activeTextField?.endEditing(false)

        tableView.beginUpdates()
        let indexPaths = [NSIndexPath(forRow: 0, inSection: 0)]
        if editing {
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        } else {
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
        tableView.endUpdates()

    }


    // MARK: Convienence

    func configurePlayerCell(playerCell: PlayerCell, forRow row: Int) {

        playerCell.textField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        playerCell.textField.delegate = self
        playerCell.textField.textColor = UIColor.darkTextColor()
        playerCell.textField.enabled = true

        if row == 0 && !editing {
            playerCell.textField.placeholder = NSLocalizedString("Add Player", comment: "")
            playerCell.textField.text = ""
        }
        else {
            var newRow: Int
            if !editing {
                newRow = row - 1
            } else {
                newRow = row
            }
            let player = rosterPresenter.presentedPlayers[newRow]

            playerCell.textField.text = player.name
            playerCell.accessibilityLabel = player.name
            playerCell.accessibilityIdentifier = player.name
        }
    }

    func indexPathForView(view: UIView) -> NSIndexPath? {
        let viewOrigin = view.bounds.origin

        let viewLocation = tableView.convertPoint(viewOrigin, fromView: view)

        return tableView.indexPathForRowAtPoint(viewLocation)
    }

}
