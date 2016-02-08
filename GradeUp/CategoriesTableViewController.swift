//
//  CategoriesTableViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/8/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    var categories = [String]()
    
    @IBAction func addCategory(sender: UIBarButtonItem) {
        
        let popUp = UIAlertController(title: "Add a category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        popUp.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "category name"
        })
        
        // create a the new category when the user presses Ok
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction) -> Void in
            let category_name = popUp.textFields![0].text!
            if category_name == "" {
                return
            }
            self.categories.insert(category_name, atIndex: 0)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Fade)
            
            // TODO: save the new category to memory
        }
        popUp.addAction(alertAction)
        presentViewController(popUp, animated: true) {() -> Void in}
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        categories = ["Maths", "French"]
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        cell.textLabel!.text = categories[cellForRowAtIndexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

