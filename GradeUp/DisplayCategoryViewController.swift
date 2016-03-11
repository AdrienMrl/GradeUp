//
//  DisplayCategoryViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class DisplayCategoryTableViewController: UITableViewController {
    
    var shouldSegEditMode = false
    var category: Category!
    
    @IBOutlet weak var bestSessionLabel: UILabel!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var lastSessionLabel: UILabel!
    
    func computeComposentValue(percentage: Float, greenVal: Float, redVal: Float) -> CGFloat {
        return CGFloat(
            (greenVal * percentage + redVal * (1.0 - percentage)) / (percentage + (1.0 - percentage))
        )
    }
    
    func computeColor(percentage: Float) -> UIColor {
        
        return UIColor(
            red:   computeComposentValue(percentage, greenVal: 0, redVal: 0.392),
            green: computeComposentValue(percentage, greenVal: 0.392, redVal: 0),
            blue:  computeComposentValue(percentage, greenVal: 0.138, redVal: 0.011), alpha: 1)
    }
    
    func setLabelColorFromScore() {
        
        let lastSessionColor = computeColor(category.sessionSuccessRate)
        let bestSessionColor = computeColor(category.bestSuccessRate)
        
        lastSessionLabel.textColor = lastSessionColor
        bestSessionLabel.textColor = bestSessionColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if category != nil {
            self.navigationItem.title = category.name
        }
        
     }
 
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if category == nil {
            return
        }
        
        lastSessionLabel?.text = String(Int(category.sessionSuccessRate * 100)) + "%"
        bestSessionLabel?.text = String(Int(category.bestSuccessRate * 100)) + "%"
        numberOfQuestionLabel?.text = String(category.qas.count)
        setLabelColorFromScore()
        
        if shouldSegEditMode {
            shouldSegEditMode = false
            self.performSegueWithIdentifier("editCategory", sender: self)
        }
        
    }
    @IBAction func unwindForDisplay(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        return !(identifier == "toTinder" && category.qas.count == 0)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nav = segue.destinationViewController as! UINavigationController
        
        if segue.identifier == "editCategory" {
            
            let editVC = nav.topViewController as! EditCategoryViewController
            editVC.category = category
            
        } else if segue.identifier == "toTinder" {
            
            if category.qas.count != 0 {
            
                let tinderVC = nav.topViewController as! TinderViewController
                tinderVC.category = category
                
            }
        }
    }
}
