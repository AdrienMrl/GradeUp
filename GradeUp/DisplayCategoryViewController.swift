
//
//  DisplayCategoryViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class DisplayCategoryViewController: UIViewController {
    
    var shouldSegEditMode = false
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.title = category?.name
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
