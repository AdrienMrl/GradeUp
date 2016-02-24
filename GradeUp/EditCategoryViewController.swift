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
    
    var recordingStuff = Recorder()
    
    let tvContr = RecordingsTableViewController()

    var timer: NSTimer?
    
    var secs = 0
    var minutes = 0

    
    var recordingMode : Recorder.RecordingMode! = nil {
        didSet {
            infoLabel.text = "Record " +
                (self.recordingMode == nil || self.recordingMode == Recorder.RecordingMode.Question ? "Question" : "Answer")
        }
    }
    
    
    @IBAction func record(sender: UIButton) {
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true)
        }
        
        secs = 0
        minutes = 0

        
        var identifier = category.qas.count

        
        if recordingMode == nil {
            recordingMode = .Question
            Recorder.start(recordingMode, categoryName: category.name, identifier: identifier)
            return
        }
        
        if recordingMode == .Question {
            recordingMode = .Answer
            Recorder.stop()
            
            timer?.invalidate()
            timer = nil
            refreshTimerLabels()
            
            return
            
        } else if Recorder.instance.recorder.recording {
            
            let newQA = Category.QA(identifier: identifier)
            
            category.qas.append(newQA)
            identifier++
            
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            recordingMode = nil
            Recorder.stop()
            return
        }
        
        Recorder.start(recordingMode, categoryName: category.name, identifier: identifier)

    }
    
    func refreshTimerLabels() {
        
        func padNumber(num: Int) -> String {
            return String(format: "%02d", num)
        }
        
        timerLabel.text = "\(padNumber(minutes)):\(padNumber(secs))"
  
    }
    
    func timerTick() {
        
        secs++
        if secs > 59 {
            secs = 0
            minutes++
        }
        
        refreshTimerLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingMode = nil

        tvContr.category = category
        tableView.delegate = tvContr
        tableView.dataSource = tvContr

    }

    @IBAction func resetStats(sender: AnyObject) {
        category.sessionSuccessRate = 0
        category.bestSuccessRate = 0
        
        for q in category.qas {
            q.time_success = 0
            q.time_failure = 0
        }
        
        Category.saveCategories()

        let view = sender.superview!!
        
        view.removeFromSuperview()

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
