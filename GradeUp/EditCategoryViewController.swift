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
    
    var recordingMode : RecordingMode! = nil {
        didSet {
            infoLabel.text = "Record " +
                (self.recordingMode == nil || self.recordingMode == .Question ? "Question" : "Answer")
        }
    }
    
    
    @IBAction func record(sender: UIButton) {
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true)
        }
        
        secs = 0
        minutes = 0
        
        Recorder.stop()
        
        
        if recordingMode == nil {
            recordingMode = .Question
            Recorder.start(recordingMode, categoryName: category.name, identifier: category.qas.count)
            return
        }
        
        if recordingMode == .Question {
            recordingMode = .Answer
            
        } else {
            let newQA = Category.QA(identifier: category.qas.count)
            
            category.qas.append(newQA)
            
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            recordingMode = .Question            
        }
        
        Recorder.start(recordingMode, categoryName: category.name, identifier: category.qas.count)

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
        
        recordingMode = nil

        tvContr.category = category
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
