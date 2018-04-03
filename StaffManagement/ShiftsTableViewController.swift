//
//  ShiftsTableViewController.swift
//  StaffManagement
//
//  Created by Ryan Maksymic on 2018-04-01.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

class ShiftsTableViewController: UITableViewController {
    
    let kShiftCellIdentifier = "ShiftCellIdentifier"
    
    var waiter : Waiter!
    var shifts : [Shift]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(waiter.name!)'s Shifts"
        shifts = Array(waiter.shifts) as! [Shift]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kShiftCellIdentifier, for: indexPath)
        let shift = shifts[indexPath.row]
        cell.textLabel?.text = "\(shift.startTime!) to \(shift.endTime!)"
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let nsvc = nav.viewControllers.first as! NewShiftViewController
        nsvc.delegate = self
    }
}
