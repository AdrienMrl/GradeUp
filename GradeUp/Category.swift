//
//  Category.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class Category: NSObject, NSCoding {
    var name: String
    
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
}
