//
//  DisplayCategoryViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class DisplayCategoryViewController: UIViewController {
    
    var lastSessionRate = 0
    var bestSessionRate = 100
    var numberOfQuestion = 0
    var shouldSegEditMode = false
    var category: Category?
    
    @IBOutlet weak var lastSessionLabel: UILabel!
    @IBOutlet weak var bestSessionLabel: UILabel!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    
    func computeColor(percentage: Int) -> UIColor {
        
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setLabelColorFromScore() {
        
        let lastSessionColor = computeColor(lastSessionRate)
        let bestSessionColor = computeColor(bestSessionRate)
        
        lastSessionLabel.textColor = lastSessionColor
        bestSessionLabel.textColor = bestSessionColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.title = category?.name
        
        lastSessionLabel?.text = String(lastSessionRate) + "%"
        bestSessionLabel?.text = String(bestSessionRate) + "%"
        numberOfQuestionLabel?.text = String(numberOfQuestion)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nav = segue.destinationViewController as! UINavigationController

        if segue.identifier == "editCategory" {
            
            let editVC = nav.topViewController as! EditCategoryViewController
            
            editVC.category = category
            
        } else if segue.identifier == "toTinder" {
            
            let tinderVC = nav.topViewController as! TinderViewController
            
            tinderVC.category = category
        }
    }
}
