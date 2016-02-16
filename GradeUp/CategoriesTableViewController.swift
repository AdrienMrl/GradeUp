//
//  CategoriesTableViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/8/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    var categories = [Category]()
    var editMode = false
    var selectedCategory: Category?
    
    @IBAction func addCategory(sender: UIBarButtonItem)
    {        
        let popUp = UIAlertController(title: "Add a category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        popUp.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "category name"
        })
        
        
        // create a the new category when the user presses Ok
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            
            (action: UIAlertAction) -> Void in
            
            if let name = popUp.textFields![0].text {
                
                let newCategory = Category(name: name)
                self.categories.append(newCategory)
                self.selectedCategory = newCategory
                self.editMode = true
                
                Category.saveCategories(self.categories)
                self.tableView.reloadData()
                
                self.performSegueWithIdentifier("displayCategory", sender: self)
            }
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
        
        Category.saveCategories(categories)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let archivedItems =
            NSKeyedUnarchiver.unarchiveObjectWithFile(Category.archiveURL.path!) as? [Category] {
                categories = archivedItems
        }
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for cell in tableView.visibleCells {
            let cell = cell as! categoryTableViewCell
            
            cell.setEditable(editing)
            if !editing && categories.count != 0 {
                categories[cell.index] = Category(name: cell.getCategoryName())
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
            cell.setCategoryName(categories[indexPath.row].name)
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        //let selectedCategory = categories[indexPath.row]
        
        editMode = false
        selectedCategory = categories[indexPath.row]
        performSegueWithIdentifier("displayCategory", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navController = segue.destinationViewController as! UINavigationController
        
        if let targetVC = navController.topViewController as? DisplayCategoryViewController {
            targetVC.shouldSegEditMode = editMode
            targetVC.category = selectedCategory
        }
    }
}

