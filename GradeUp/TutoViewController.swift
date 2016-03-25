//
//  TutoPageViewController.swift
//  GradeUp
//
//  Created by Adrien morel on 3/17/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class TutoViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateControllersArray()
        createPageViewController()
        setupPageControl()
    }
    
    var controllers = [UIViewController]()
    
    var tutos = [
        "This app will help you memorize things by randomly testing you on questions you recorded with your voice.",
        "Tap on the red button to record a question. Tap again to record the answer.",
        "Swipe the card left or right if you had or hadn’t the answer"
    ]
    var colors = [
        UIColor(red: 15 / 255, green: 138 / 255, blue: 180 / 255, alpha: 1),
        UIColor(red: 192 / 255, green: 74 / 255, blue: 104 / 255, alpha: 1),
        UIColor(red: 44 / 255, green: 88 / 255, blue: 103 / 255, alpha: 1)
    ]

    func populateControllersArray() {
        for i in 0...tutos.count - 1 {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("ViewController0") as! PageItemViewController
            controller.index = i
            controller.text = tutos[i]
            controller.image = UIImage(named: "screen\(i + 1)")
            controller.color = colors[i]
            
            controllers.append(controller)
        }
        controllers.append(storyboard!.instantiateViewControllerWithIdentifier("SplitViewController"))
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        if !controllers.isEmpty {
            pageController.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.orangeColor()
        appearance.currentPageIndicatorTintColor = UIColor.grayColor()
        appearance.backgroundColor = UIColor.clearColor()
    }
    
 
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = 0
        
        if let vc = viewController as? PageItemViewController {
            index = vc.index
        } else {
            index = controllers.count - 1
        }
       
        if index == 0 {
            return nil
        }
        
        return controllers[index - 1]
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = 0
        
        if let vc = viewController as? PageItemViewController {
            index = vc.index
        } else {
            index = controllers.count - 1
        }
        
        if index == controllers.count - 1 {
            return nil
        }
        
        return controllers[index + 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (completed) {
            
            let viewController = pageViewController.viewControllers!.last!
            
            if let _ = viewController as? UISplitViewController {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool((controllers[controllers.count - 2] as! PageItemViewController).doNotShowSwitch.on, forKey: "understood")
            }
        }
    }
}
