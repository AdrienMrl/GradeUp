//
//  TinderViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/18/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit
import Darwin
import LTMorphingLabel

class TinderViewController: UIViewController, MagicWavesViewDelegate {
    
    var swiper: Swiper!
    var category: Category!
    var currentQuestion: Int! = nil
    @IBOutlet weak var questionLabel: LTMorphingLabel!
    @IBOutlet weak var draggableView: MagicWavesView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var hearAgainButton: UIButton!
    
    var questionUp: Category.QA!
    var questionDown: Category.QA!
    
    var success: Float = 0.0
    var failure: Float = 0.0
    
    func updateMeters() -> Float {
        
        if let player = Recorder.instance.player {
            player.updateMeters()
            
            return player.averagePowerForChannel(0)
        }
        
        return -160
    }
    
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
        swiper?.swipe(Swiper.SwipeDirection.Right)
    }
    
    @IBAction func failed() {
        swiper?.swipe(Swiper.SwipeDirection.Left)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        swiper = Swiper(addView: addSwipeView)
        swiper.rightMessage = "DUNNO"
        swiper.leftMessage = "GOT IT"
        let trashImage = UIImage(named: "trash")
        swiper.botImageView = UIImageView(image: trashImage)
        questionLabel.morphingEffect = .Evaporate
    }
    
    override func viewDidAppear(animated: Bool) {
        
        swiper.rightAction = {() -> Bool in
            self.category.qas[self.currentQuestion].time_success += 1
            self.success += 1
            self.pullQuestion()
            return false
        }
        
        swiper.leftAction = {() -> Bool in
            self.category.qas[self.currentQuestion].time_failure += 1
            self.failure += 1
            self.pullQuestion()
            return false
        }
        
        swiper.botAction = {() -> Bool in
            do {
                try self.category.deleteRecordFileBy(identifier: self.category.qas[self.currentQuestion!].identifier)
            } catch let error as NSError {
                print("Error: \(error)")
            }
            let shouldExitTest = self.category.qas.count <= 1
            self.category.qas.removeAtIndex(self.currentQuestion!)
            Category.saveCategories()
            if shouldExitTest {
                self.performSegueWithIdentifier("unwindForDisplay", sender: self)
            } else {
                self.pullQuestion()
            }
            return shouldExitTest
        }
    }
    
    func addSwipeView() -> UIView {
        
        let swipeView = MagicWavesView()
        let question = pullQuestion()
        
        swipeView.delegate = self
        swipeView.question = question
        
        questionUp = questionDown
        questionDown = question
        
        if questionUp != nil {
            questionLabel.text = "Question #\(questionUp.identifier + 1)"
            self.playStuff(.Question, question: questionUp)
        }
        
        view.addSubview(swipeView)
        
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            swipeView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 8),
            swipeView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -8),
            swipeView.topAnchor.constraintEqualToAnchor(answerButton.bottomAnchor, constant: 12),
            swipeView.bottomAnchor.constraintEqualToAnchor(hearAgainButton.topAnchor, constant: -12),
            ])
        
        swipeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TinderViewController.swipeViewTouched)))
        swipeView.backgroundColor = question.color;
    
        let successLabel = UILabel()
        swipeView.addSubview(successLabel)

        successLabel.text = "\(question.getSuccessRatePercent())% success"
        
        successLabel.textColor = UIColor.whiteColor()
        successLabel.font = successLabel.font.fontWithSize(20)
        successLabel.font = UIFont(name: "System-Thin", size: 20)
        
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            successLabel.trailingAnchor.constraintEqualToAnchor(swipeView.trailingAnchor, constant: -16),
            successLabel.topAnchor.constraintEqualToAnchor(swipeView.topAnchor, constant: 16)])
        
        
        return swipeView
    }
    
    func swipeViewTouched() {
        playStuff(.Answer, question: questionUp)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playStuff(type: Recorder.RecordingMode, question: Category.QA) {
        Recorder.play(type, categoryName: category.name, identifier: question.identifier)
    }
    
    @IBAction func hearQuestion(sender: UIButton) {
        playStuff(.Question, question: questionUp)
    }
    
    @IBAction func hearAnswer(sender: AnyObject) {
        playStuff(.Answer, question: questionUp)
    }
    
    func pullQuestion() -> Category.QA {
        
        
        func sortQA() {
            category.qas.sortInPlace {
                
                // add a number between + or - 50%
                var randomizer = Float(arc4random()) / Float(UINT32_MAX)
                randomizer -= 0.5
                randomizer /= 2
                
                return $0.getSuccessRate() < $1.getSuccessRate() + randomizer
            }
        }
        
        if currentQuestion == nil {
            sortQA()
            currentQuestion = 0
        } else {
            
            currentQuestion! += 1
            
            if currentQuestion >= category.qas.count {
                sortQA()
                currentQuestion = 0
            }
        }

        questionLabel.text = "Question #\(category.qas[currentQuestion].identifier + 1)"

        updateSuccessRate()

        return category.qas[currentQuestion]
    }
    
    func updateSuccessRate() {
        
        if success + failure == 0 {
            return
        }
        
        category.sessionSuccessRate = success / (success + failure)
        
        Category.saveCategories()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if category.bestSuccessRate < category.sessionSuccessRate {
            category.bestSuccessRate = category.sessionSuccessRate
        }
        
    }
}
