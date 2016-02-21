//
//  swipeView.swift
//  GradeUp
//
//  Created by Adrien morel on 2/20/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class SwipeView: UIView {


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func clone() -> SwipeView {
        return NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(self)) as! SwipeView
    }
}
