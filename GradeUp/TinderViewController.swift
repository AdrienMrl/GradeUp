//
//  TinderViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 2/18/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit
import Darwin
import RandomColorSwift
import LTMorphingLabel

class TinderViewController: UIViewController, MagicWavesViewDelegate {

    var swiper: Swiper!
    var category: Category!
    var currentQuestion: Int! = nil
    @IBOutlet weak var questionLabel: LTMorphingLabel!
    @IBOutlet weak var draggableView: MagicWavesView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var hearAgainButton: UIButton!
    
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
        swiper?.swipe(true)
    }
    
    @IBAction func failed() {
        swiper?.swipe(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        swiper = Swiper(addView: addSwipeView)
        questionLabel.morphingEffect = .Evaporate
    }
    
    override func viewDidAppear(animated: Bool) {
        
        swiper.rightAction = {
            self.category.qas[self.currentQuestion].time_success++
            self.success++
            self.pullQuestion()

        }
        swiper.leftAction = {
            self.category.qas[self.currentQuestion].time_failure++
            self.failure++
            self.pullQuestion()
        }
        
    }
    
    func addSwipeView() -> UIView {
        
        let swipeView = MagicWavesView()
        
        swipeView.delegate = self
        
        view.addSubview(swipeView)
        
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            swipeView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 8),
            swipeView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -8),
            swipeView.topAnchor.constraintEqualToAnchor(answerButton.bottomAnchor, constant: 12),
            swipeView.bottomAnchor.constraintEqualToAnchor(hearAgainButton.topAnchor, constant: -12),
        ])
        
        swipeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "swipeViewTouched"))
        swipeView.backgroundColor = randomColor()
    
        let successLabel = UILabel()
        swipeView.addSubview(successLabel)

        successLabel.text = "\(category.qas[currentQuestion].getSuccessRatePercent())% success"
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
        playStuff(.Answer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playStuff(type: Recorder.RecordingMode) {
        Recorder.play(type, categoryName: category.name, identifier: category.qas[currentQuestion].identifier)
    }
    
    @IBAction func hearQuestion(sender: UIButton) {
        playStuff(.Question)
    }
    
    @IBAction func hearAnswer(sender: AnyObject) {
        playStuff(.Answer)
    }
    
    func pullQuestion() {
        
        
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
            
            currentQuestion!++
            
            if currentQuestion >= category.qas.count {
                sortQA()
                currentQuestion = 0
            }
        }

        questionLabel.text = "Question #\(category.qas[currentQuestion].identifier + 1)"
        updateSuccessRate()
        playStuff(.Question)
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
