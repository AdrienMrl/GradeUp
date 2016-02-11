
//
//  DisplayCategoryViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class DisplayCategoryViewController: UIViewController {

    var goToEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.performSegueWithIdentifier("editCategory", sender: self)

        print(goToEdit)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindForEditSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("unwindinnng")
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
