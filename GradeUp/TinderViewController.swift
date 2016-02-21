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
    
    @IBAction func dragTinderView(sender: UIPanGestureRecognizer) {
        swiper.drag(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullQuestion()
        
        swiper = Swiper(target: draggableView)
        
        swiper.rightAction = {
            print("swipe right")
        }
        swiper.leftAction = {
            print("swipe left")
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
        questionLabel.text = "Question #\(currentQuestion)"
    }

    @IBAction func gotIt(sender: AnyObject) {
        pullQuestion()
        swiper.swipe(true)
    }

    @IBAction func fail(sender: AnyObject) {
        pullQuestion()
        swiper.swipe(false)
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
