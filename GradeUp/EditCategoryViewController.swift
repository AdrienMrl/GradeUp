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
                (self.recordingMode == nil ||
                    self.recordingMode == Recorder.RecordingMode.Question ? "Question" : "Answer")
        }
    }
    
    func getCurrentQuestionIdentifier() -> Int {
        
        // FIXME: BUG !!!! identifier will collide with existing identifier sometimes
        return category.qas.count
    }
    
    @IBAction func record(sender: UIButton) {
        
        if recordingMode == nil {
            
            recordQuestion()
            
        } else if recordingMode == .Question {
            
            stopRecording()
            recordAnswer()
            
        } else if recordingMode == .Answer {
            
            stopRecording()
            let newQA = Category.QA(identifier: getCurrentQuestionIdentifier())
            category.qas.append(newQA)
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
        }
    }
    
    
    func record(type: Recorder.RecordingMode) {
        
        let identifier = getCurrentQuestionIdentifier()
        
        Recorder.start(type, categoryName: category.name, identifier: identifier)
        recordingMode = type
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true)
        }
    }
    
    func recordQuestion() {
        record(.Question)
    }
    
    func recordAnswer() {
        record(.Answer)
    }
    
    func stopRecording() {
        Recorder.stop()
        recordingMode = nil
        timer?.invalidate()
        timer = nil
        secs = 0
        minutes = 0
        refreshTimerLabels()
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
}
