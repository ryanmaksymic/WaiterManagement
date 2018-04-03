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
    let kPresentNewShiftSegue = "PresentNewShiftSegue"
    var waiter : Waiter!
    var shifts = [Shift]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(waiter.name!)'s Shifts"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shifts = Array(waiter.shifts) as! [Shift]
        shifts.sort { (shift1, shift2) -> Bool in
            return shift1.startTime < shift2.startTime
        }
        tableView.reloadData()
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        cell.textLabel?.text = "\(dateFormatter.string(from: shift.startTime)): \(timeFormatter.string(from: shift.startTime)) to \(timeFormatter.string(from: shift.endTime))"
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kPresentNewShiftSegue {
            let nc = segue.destination as! UINavigationController
            let nsvc = nc.viewControllers.first as! NewShiftViewController
            nsvc.delegate = self
        }
    }
}
