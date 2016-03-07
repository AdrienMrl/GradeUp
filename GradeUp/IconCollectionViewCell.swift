//
//  IconCollectionViewCell.swift
//  GradeUp
//
//  Created by Adrien morel on 3/7/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconButton: UIButton!
    var iconName: String!
    
    @IBAction func IconClick(sender: UIButton) {
        
        let collectionView = superview! as! UICollectionView
        
        print("clicked \(collectionView.indexPathForCell(self))")
        
        let tableViewCellContentView = collectionView.superview! 
        let tableViewCell = tableViewCellContentView.superview! as! EditIconTableViewCell
        tableViewCell.onIconSelected?(iconName)
    }
}
