//
//  NewShiftViewController.swift
//  StaffManagement
//
//  Created by Ryan Maksymic on 2018-04-02.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

class NewShiftViewController: UIViewController {
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    var delegate: ShiftsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endTimePicker.date = startTimePicker.date + TimeInterval(60*60*8)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancelNewShift(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNewShift(_ sender: UIBarButtonItem) {
        let restaurantManager = RestaurantManager.sharedManager() as! RestaurantManager
        restaurantManager.newShift(from: startTimePicker.date, to: endTimePicker.date, for: delegate.waiter)
        dismiss(animated: true, completion: nil)
    }
}
