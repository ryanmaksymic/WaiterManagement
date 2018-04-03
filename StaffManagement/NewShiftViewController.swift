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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
