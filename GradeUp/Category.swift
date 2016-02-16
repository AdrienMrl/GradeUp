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
    
    class QA {
        var question: String
        var answer: String
        
        init(q: String, a: String) {
            question = q
            answer = a
        }
    }
    
    var qas: Array<QA> = []
    
    init(name: String) {
        self.name = name
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject() as! String
        
        self.init(name: name)
    }
    
    static func saveCategories(categories: Array<Category>) -> Bool {
        return NSKeyedArchiver.archiveRootObject(categories, toFile: archiveURL.path!)
    }
}
