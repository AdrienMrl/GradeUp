//
//  RecordingsTableViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/15/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class RecordingsTableViewController: UITableViewController {

    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.qas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recordingCellPrototype", forIndexPath: indexPath)
            as! EditCategoryTableViewCell

        let question = category.qas[indexPath.row]
        cell.questionLabel.text = "Question #\(question.identifier + 1)"
        cell.questionSuccessRateLabel.text = "\(question.getSuccessRatePercent())%"
        
        
        func padNumber(num: Int) -> String {
            return String(format: "%02d", num)
        }
        
        cell.questionDurationLabel.text = "\(padNumber(question.record_duration / 60)):\(padNumber(question.record_duration % 60))"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Recorder.play(.Question, categoryName: category.name, identifier: category.qas[indexPath.row].identifier)
        
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            do {
                try category.deleteRecordFileBy(identifier: category.qas[indexPath.row].identifier)
            } catch let error as NSError {
                print("Error: \(error)")
            }
            
            category.qas.removeAtIndex(indexPath.row)
            Category.saveCategories()
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
        }
    }
}