//
//  HistoryTableViewController.swift
//  FlowerSnap
//
//  Created by 陆依鸣 on 2018/11/23.
//  Copyright © 2018 陆依鸣. All rights reserved.
//

import UIKit
import os.log

class HistoryTableViewController: UITableViewController {
    
    var historys = [HistoryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Load any saved historys, otherwise load sample data.
        if let savedHistorys = History.loadHistorys() {
            historys += savedHistorys
        }
        else {
            // Load the sample data.
            historys += History.loadSampleHistorys()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let history = historys[indexPath.row]

        cell.textLabel?.text = history.title
        cell.imageView?.image = history.sourceImage.resizedImage(to: CGSize(width: 50, height: 44))
        
        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            historys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            History.saveHistorys(historys: historys)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = historys[fromIndexPath.row]
        historys.remove(at: fromIndexPath.row)
        historys.insert(movedObject, at: to.row)
        History.saveHistorys(historys: historys)
    }
 
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResultFromHistory" {
            guard let resultViewController = segue.destination as? ResultViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? HistoryTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nil")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHistory = historys[indexPath.row]
            resultViewController.predictIndex = selectedHistory.predictIndex
            resultViewController.predictProbs = selectedHistory.predictProbs
            resultViewController.sourceImage = selectedHistory.sourceImage
        }
    }
}
