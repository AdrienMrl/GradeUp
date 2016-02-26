//
//  Category.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class Category: NSObject, NSCoding {
    
    static let archiveURL: NSURL = {
        let documentsDirectories =
            NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("categories.archive")
    }()
    
    var name: String
    var sessionSuccessRate: Float
    var bestSuccessRate: Float
    static var categories: [Category] =
    {
        if let object = NSKeyedUnarchiver.unarchiveObjectWithFile(Category.archiveURL.path!) as? [Category] {
            return object
        }
        
        return []
    }() {
        didSet {
            saveCategories()
        }
    }
    
    class QA: NSObject, NSCoding {
        
        let identifier: Int
        var time_success = 0
        var time_failure = 0

        init(identifier: Int) {
            self.identifier = identifier
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            self.init(identifier: aDecoder.decodeObjectForKey("identifier") as! Int)
            
            self.time_success = aDecoder.decodeObjectForKey("time_success") as! Int
            self.time_failure = aDecoder.decodeObjectForKey("time_failure") as! Int
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            
            aCoder.encodeObject(identifier, forKey: "identifier")
            aCoder.encodeObject(time_success, forKey: "time_success")
            aCoder.encodeObject(time_failure, forKey: "time_failure")
        }
        
        func getSuccessRate() -> Float {
            let total = time_success + time_failure
            
            return total == 0 ? 0 : Float(time_success) / Float(total)
        }
    }
    
    // A list of Question and Answers identifiers
    var qas: Array<QA>! = [] {
        didSet {
            Category.saveCategories()
        }
    }
    
    init(name: String) {
        self.name = name
        self.sessionSuccessRate = 0
        self.bestSuccessRate = 0
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(qas, forKey: "qas")
        aCoder.encodeObject(sessionSuccessRate, forKey: "sessionSuccessRate")
        aCoder.encodeObject(bestSuccessRate, forKey: "bestSuccessRate")
    }
    
    // debug function
    func emergencyRecoverQA(howMany: Int) -> [QA] {
        var qas : [QA] = []
        
        for i in 0...howMany {
            qas.append(QA(identifier: i))
        }
        
        return qas
    }
    
    required convenience init?(coder aDecoder: NSCoder) {

        let name = aDecoder.decodeObjectForKey("name") as! String

        self.init(name: name)
        
        self.qas = aDecoder.decodeObjectForKey("qas") as! Array<QA>
        
//        self.qas = emergencyRecoverQA(11)
        
        self.sessionSuccessRate = aDecoder.decodeObjectForKey("sessionSuccessRate") as! Float
        self.bestSuccessRate = aDecoder.decodeObjectForKey("bestSuccessRate") as! Float

    }

    static func saveCategories() -> Bool {
        return NSKeyedArchiver.archiveRootObject(Category.categories, toFile: archiveURL.path!)
    }
}
