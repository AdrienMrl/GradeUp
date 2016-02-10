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
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            
            // TODO: save the new category to memory
        }
        popUp.addAction(alertAction)
        presentViewController(popUp, animated: true) {() -> Void in}
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return categories.count != 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            categories.removeAtIndex(indexPath.row)
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        categories = []
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for cell in tableView.visibleCells {
            let cell = cell as! categoryTableViewCell
            
            cell.setEditable(editing)
            if !editing && categories.count != 0 {
                categories[cell.index] = cell.getCategoryName()
            }
        }

    }
  
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = categoryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "categoryCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! categoryTableViewCell

        cell.setEditable(tableView.editing)
        cell.index = indexPath.row
        cell.userInteractionEnabled = categories.count != 0

        
        if categories.count == 0 {
            cell.setCategoryName("No category")
        } else {
            cell.setCategoryName(categories[indexPath.row])
        }
        return cell as UITableViewCell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count == 0 ? 1 : categories.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

