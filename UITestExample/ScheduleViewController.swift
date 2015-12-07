//
//  ScheduleViewController.swift
//  UITestExample
//
//  Created by Erik Bigler on 12/3/15.
//  Copyright © 2015 SunSquared. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController, SchedulePresenterDelegate {

    // MARK: Properties
    private var schedulePresenter = SchedulePresenter()

    var gameWrapper = GameWrapper()

    private var isReturningFromDetailView = false

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        schedulePresenter.delegate = self

        schedulePresenter.setSchedule(SettingsManager.teamSettings.schedule)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        if(isReturningFromDetailView) {
            if(gameWrapper.canceled){ return }
            if(gameWrapper.isNew) {
                print("inserting new game")
                schedulePresenter.insertGame(gameWrapper.game)
            } else {
                schedulePresenter.updateGame(gameWrapper.game)
            }
            isReturningFromDetailView = false
        }
    }

    // MARK: Segues

    @IBAction func unwindToScheduleView (sender: UIStoryboardSegue) {
        isReturningFromDetailView = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let newGameView = segue.destinationViewController as? NewGameViewController {
            newGameView.wrapper = gameWrapper
        }
        
    }

    // MARK: IBFuctions

    @IBAction func addNewGame() {
        gameWrapper = GameWrapper()
        self.performSegueWithIdentifier("game detail", sender: self)
    }
    
    // MARK: UITableViewDataSource

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulePresenter.count
    }

    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return tableView.dequeueReusableCellWithIdentifier("Game Cell", forIndexPath: indexPath)
    }

    override func tableView(_: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(_: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(_: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }

        let game = schedulePresenter.presentedGames[indexPath.row]

        schedulePresenter.removeGame(game)
    }

    // MARK: UITableViewDelegate

    override func tableView(_: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch cell {
        case let gameCell as GameCell:
            configureGameCell(gameCell, forRow: indexPath.row)
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
        gameWrapper.gameIndex = indexPath.row
        gameWrapper.game = schedulePresenter.presentedGames[indexPath.row]
        gameWrapper.isNew = false;
        self.performSegueWithIdentifier("game detail", sender: self)
    }

    // MARK: RosterPresenterDelegate

    func schedulePresenterDidRefreshCompleteLayout(schedulePresenter: SchedulePresenterType) {
        tableView.reloadData()
    }

    func schedulePresenterWillChangeScheduleLayout(schedulePresenter: SchedulePresenterType) {
        tableView.beginUpdates()
    }

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didAddGame game: Game, atIndex index: Int) {

        //ask presenter what index the game should be at considering date of game to others
        let indexPathsForInsertion = [NSIndexPath(forRow: index, inSection: 0)]

        tableView.insertRowsAtIndexPaths(indexPathsForInsertion, withRowAnimation: .Fade)

    }

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didRemoveGame game: Game, atIndex index: Int) {
        let indexPaths = [NSIndexPath(forRow: index, inSection: 0)]

        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

    }

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didUpdateGame game: Game, atIndex index: Int) {
        tableView.endUpdates()

        tableView.beginUpdates()

        let indexPath = NSIndexPath(forRow: index, inSection: 0)

        if let gameCell = tableView.cellForRowAtIndexPath(indexPath) as? GameCell {
            configureGameCell(gameCell, forRow: index)
        }

    }

    func schedulePresenter(schedulePresenter: SchedulePresenterType, didMoveGame game: Game, fromIndex: Int, toIndex: Int) {
        let fromIndexPath = NSIndexPath(forRow: fromIndex, inSection: 0)

        let toIndexPath = NSIndexPath(forRow: toIndex, inSection: 0)
        
        tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
    
    func schedulePresenterDidChangeScheduleLayout(schedulePresenter: SchedulePresenterType) {
        tableView.endUpdates()
    }


    // MARK: Convienence

    func configureGameCell(gameCell: GameCell, forRow row: Int) {

        let game = schedulePresenter.presentedGames[row]

        gameCell.locationLabel.text = game.atHome ? "vs" : "@"
        gameCell.opponentLabel.text = game.opponent.name
        if(game.isOver) {
            hideScores(false, forGameCell: gameCell)
            gameCell.teamScoreLabel.text = String(game.teamScore)
            gameCell.opponentScoreLabel.text = String(game.opponentScore)
            if(game.teamWon) {
                gameCell.winLossLabel.text = "W"
            } else {
                gameCell.winLossLabel.text = "L"
            }
        } else {
            hideScores(true, forGameCell: gameCell)
        }

        gameCell.dateLabel.text = game.dateDescription

        gameCell.accessibilityIdentifier = game.opponent.name
    }

    func hideScores(shouldHide: Bool, forGameCell gameCell: GameCell) {
        gameCell.teamScoreLabel.hidden = shouldHide
        gameCell.opponentScoreLabel.hidden = shouldHide
        gameCell.winLossLabel.hidden = shouldHide
        gameCell.scoreSeperator.hidden = shouldHide
    }
}

public struct GameWrapper {
    var game = Game()
    var isNew = true
    var gameIndex: Int?
    var canceled = true
}
