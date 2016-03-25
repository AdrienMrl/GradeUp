//
//  PageItemViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 3/22/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class PageItemViewController: UIViewController {
    
    @IBOutlet weak var screenShot: UIImageView!
    @IBOutlet weak var info: UILabel!
    var text: String!
    var image: UIImage!
    var color: UIColor!
    var index = 0;
    
    @IBOutlet weak var doNotShowSwitch: UISwitch!
    @IBOutlet weak var doNotShowLabel: UILabel!
    
    @IBAction func showTuto(sender: UISwitch) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        info.text = text
        screenShot.image = image
        view.backgroundColor = color
        
        if index != 2 {
            doNotShowLabel.hidden = true
            doNotShowSwitch.hidden = true
        }
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
