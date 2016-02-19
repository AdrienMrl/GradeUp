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
    
    func setLabelColorFromScore() {
        let lastSessionColor = UIColor(red: CGFloat(100 - lastSessionRate) / CGFloat(100), green: CGFloat(lastSessionRate) / CGFloat(100), blue: 0, alpha: 1)
        let bestSessionColor = UIColor(red: CGFloat(100 - bestSessionRate) / CGFloat(100), green: CGFloat(bestSessionRate) / CGFloat(100), blue: 0, alpha: 1)
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
    
    @IBAction   func unwindForDisplay(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editCategory" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let editVC = nav.topViewController as! EditCategoryViewController
            
            editVC.category = category
        }
        
    }
}
