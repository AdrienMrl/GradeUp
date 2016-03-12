//
//  CategoriesTableViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/8/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var editMode = false
    var selectedCategory: Category?
    var editingIcon : Int? = nil

    
    func iconSelected(imageName: String, catIndex: Int) {
        editingIcon = nil
        Category.categories[catIndex].iconName = imageName
        reloadAnimated()
        Category.saveCategories()
    }
    
    @IBAction func addCategory(sender: UIBarButtonItem)
    {
        shouldDisplayBackGround(false)
        let popUp = UIAlertController(title: "Add a category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        popUp.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "category name"
        })
        
        
        // create a the new category when the user presses Ok
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            
            (action: UIAlertAction) -> Void in
            
            if let name = popUp.textFields![0].text {
                
                if name == "" {
                    return
                }
                
                let newCategory = Category(name: name)
                Category.categories.append(newCategory)
                self.selectedCategory = newCategory
                self.editMode = true
                
                self.tableView.reloadData()
                
                self.performSegueWithIdentifier("displayCategory", sender: self)
            }
        }
        
        popUp.addAction(alertAction)
        presentViewController(popUp, animated: true) {() -> Void in}
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return Category.categories.count != 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let selectedCategory = Category.categories[indexPath.row]
            
            for qa in selectedCategory.qas {
                do {
                try selectedCategory.deleteRecordFileBy(identifier: qa.identifier)
                } catch let error as NSError {
                    print("Error: \(error)")
                }
            }
            
            Category.categories.removeAtIndex(indexPath.row)
            reloadAnimated()
            if (Category.categories.count == 0) {
                shouldDisplayBackGround(true)
            }
        }
    }
    
    func shouldDisplayBackGround(should:Bool) {
        if (should) {
            let backgroundLabel = UILabel()
            backgroundLabel.text = "No Category"
            backgroundLabel.textAlignment = NSTextAlignment.Center
            backgroundLabel.font = UIFont(name: "Arial", size: 20)
            backgroundLabel.textColor = UIColor.lightGrayColor()
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.backgroundView = backgroundLabel
        }
        else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            tableView.backgroundView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (Category.categories.count == 0) {
            shouldDisplayBackGround(true)
        }
        navigationItem.leftBarButtonItem = editButtonItem()        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for cell in tableView.visibleCells {

            if let cell = cell as? categoryTableViewCell {
        
                cell.setEditable(editing)
                if !editing && Category.categories.count != 0 {
                    Category.categories[cell.index].name = cell.nameTextField.text!
                }
            }
        }
        
        if let editingId = editingIcon {
            editingIcon = nil
            
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: editingId, inSection: 0)], withRowAnimation: .Fade)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if tableView.editing == true && editingIcon == indexPath.row {
            let customCell = tableView.dequeueReusableCellWithIdentifier("editIconCell", forIndexPath: indexPath) as! EditIconTableViewCell
            
            let img = Category.images
            if let position = img.indexOf(Category.categories[indexPath.row].iconName) {
                if position > 0 {
                    swap(&Category.images[position], &Category.images[0])
                    customCell.collectionView.reloadData()
                }
            }
            customCell.onIconSelected = { (imageName: String) -> () in
                self.iconSelected(imageName, catIndex: indexPath.row)
            }
            
            cell = customCell
        }
        else {
            let customCell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! categoryTableViewCell
            
            customCell.setEditable(tableView.editing)
            customCell.index = indexPath.row
            
            let category = Category.categories[indexPath.row]
            customCell.setCategoryName(category.name)
            customCell.setQuestionsCount(category.qas.count)
            customCell.onIconTap = { (index: Int) in
                self.editingIcon = index
                self.reloadAnimated()
            }
            customCell.icon.image = UIImage(named: category.iconName)
            cell = customCell
            
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.categories.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let selectedCategory = categories[indexPath.row]
        
        editMode = false
        selectedCategory = Category.categories[indexPath.row]
        performSegueWithIdentifier("displayCategory", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as! UINavigationController
        
        if let targetVC = navController.topViewController as? DisplayCategoryTableViewController {
            targetVC.shouldSegEditMode = editMode
            targetVC.category = selectedCategory
        }
    }
    
    func reloadAnimated() {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadAnimated()
    }
}
