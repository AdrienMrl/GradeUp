//
//  TinderViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/18/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {

    var category: Category!
    var currentQuestion: Int = 0
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hearQuestion(sender: UIButton) {
        Recorder.playRecording(.Question, name: category.name, identifier: currentQuestion)
    }
    
    @IBAction func hearAnswer(sender: AnyObject) {
        Recorder.playRecording(.Answer, name: category.name, identifier: currentQuestion)
    }
    
    func pullQuestion() {
        currentQuestion = Recorder.playRandomQuestion(category)
        questionLabel.text = "Question #\(currentQuestion)"
    }

    @IBAction func gotIt(sender: AnyObject) {
        pullQuestion()
    }

    @IBAction func fail(sender: AnyObject) {
        pullQuestion()
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
