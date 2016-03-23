//
//  EditCategoryViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit
import LTMorphingLabel

class EditCategoryViewController: UIViewController, MagicWavesViewDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timerLabel: LTMorphingLabel!
    @IBOutlet weak var infoLabel: LTMorphingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waveView: MagicWavesView!
    
    var category: Category!
    
    let tvContr = RecordingsTableViewController()

    var timer: NSTimer?
    
    var secs = 0
    var minutes = 0
    var question_duration = 0

    func updateMeters() -> Float {
       let recorder = Recorder.instance.recorder
        
        if recorder == nil {
            return -160
        }

        recorder.updateMeters()

        return recorder.averagePowerForChannel(0)
    }
    
    var recordingMode : Recorder.RecordingMode! = nil {
        didSet {
            infoLabel.text = "Record " +
                (self.recordingMode == nil ||
                    self.recordingMode == Recorder.RecordingMode.Question ? "Question" : "Answer")
        }
    }
    
    func getCurrentQuestionIdentifier() -> Int {
        
        if let greatestIdQA = category.qas.maxElement({(a: Category.QA, b: Category.QA) -> Bool in
            return a.identifier < b.identifier}) {
            return greatestIdQA.identifier + 1
        }
        else {
        return 0
        }
    }
    
    @IBAction func record(sender: UIButton) {
        
        if recordingMode == nil {
            
            recordQuestion()
            
        } else if recordingMode == .Question {
            
            question_duration = secs + minutes * 60
            stopRecording()
            recordAnswer()
            
        } else if recordingMode == .Answer {
            
            stopRecording()
            
            let newQA = Category.QA(identifier: getCurrentQuestionIdentifier(), record_duration: question_duration)
            category.qas.append(newQA)
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
        }
    }
    
    
    func record(type: Recorder.RecordingMode) {
        
        let identifier = getCurrentQuestionIdentifier()
        
        Recorder.start(type, categoryName: category.name, identifier: identifier)
        recordingMode = type
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(EditCategoryViewController.timerTick), userInfo: nil, repeats: true)
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
        
        secs += 1
        if secs > 59 {
            secs = 0
            minutes += 1
        }
        
        refreshTimerLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingMode = nil
        
        tvContr.category = category
        tableView.delegate = tvContr
        tableView.dataSource = tvContr
        waveView.delegate = self
        
    }
}
