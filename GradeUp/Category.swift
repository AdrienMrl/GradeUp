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
    
    class QA: NSObject, NSCoding {
        
        var identifier: Int
        var success_rate_total = 0
        var success_rate_session = 0

        init(identifier: Int) {
            self.identifier = identifier
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            self.init(identifier: aDecoder.decodeObject() as! Int)
            self.success_rate_total = aDecoder.decodeObject() as! Int
            self.success_rate_session = aDecoder.decodeObject() as! Int
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            
            aCoder.encodeObject(identifier)
            aCoder.encodeObject(success_rate_total)
            aCoder.encodeObject(success_rate_session)
        }
    }
    
    // A list of Question and Answers identifiers
    var qas: Array<QA>! = []
    
    init(name: String) {
        self.name = name
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(qas, forKey: "qas")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {

        let name = aDecoder.decodeObjectForKey("name") as! String

        self.init(name: name)
        
        self.qas = aDecoder.decodeObjectForKey("qas") as! Array<QA>
    }
    
    static func saveCategories(categories: Array<Category>) -> Bool {
        return NSKeyedArchiver.archiveRootObject(categories, toFile: archiveURL.path!)
    }
}
