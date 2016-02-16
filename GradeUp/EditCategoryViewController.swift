//
//  EditCategoryViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class EditCategoryViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category!
    
    let tvContr = RecordingsTableViewController()

    var timer: NSTimer?
    
    var secs = 0
    var minutes = 0
    
    enum RecordingMode {
        case Question
        case Answer
    }
    
    var recordingMode : RecordingMode = RecordingMode.Question {
        didSet {
            infoLabel.text = "Record " + (self.recordingMode == .Question ? "Question" : "Answer")
        }
    }
    
    
    @IBAction func record(sender: UIButton) {
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true)
        }
        
        if recordingMode == .Question {
            recordingMode = .Answer
        } else {
            //tvController
            recordingMode = .Question
        }
    }
    
    func timerTick() {
        
        secs++
        if secs > 59 {
            secs = 0
            minutes++
        }
        
        func padNumber(num: Int) -> String {
            return String(format: "%02d", num)
        }
        
        timerLabel.text = "\(padNumber(minutes)):\(padNumber(secs))"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingMode = .Question

        tvContr.category = self.category
        tableView.delegate = tvContr
        tableView.dataSource = tvContr
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
