//
//  TinderViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/18/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {

    var swiper: Swiper!
    var category: Category!
    var currentQuestion: Int = 0
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var draggableView: SwipeView!
    
    var success: Float = 0.0
    var failure: Float = 0.0
    
    @IBAction func dragTinderView(sender: UIPanGestureRecognizer) {
        swiper?.drag(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullQuestion()
        success = 0
        failure = 0
    }

    @IBAction func gotIt() {
        swiper?.swipe(true)
    }
    
    @IBAction func failed() {
        swiper?.swipe(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        swiper = Swiper(target: draggableView)
        
        swiper.rightAction = {
            self.success++
            self.pullQuestion()

        }
        swiper.leftAction = {
            self.failure++
            self.pullQuestion()
        }

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
        questionLabel.text = "Question #\(currentQuestion + 1)"
        updateSuccessRate()
    }
    
    func updateSuccessRate() {
        
        if success + failure == 0 {
            return
        }
        
        category.sessionSuccessRate = success / (success + failure)
        
        if category.bestSuccessRate < category.sessionSuccessRate {
           category.bestSuccessRate = category.sessionSuccessRate
        }
        
        Category.saveCategories()
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
