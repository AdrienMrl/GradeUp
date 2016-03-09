//
//  EditIconTableViewCell.swift
//  GradeUp
//
//  Created by Adrien morel on 3/7/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class EditIconTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var onIconSelected : ((String) -> ())?
    
    var images = ["animal",
        "apple",
        "basketball",
        "book",
        "boy-face",
        "chemistry",
        "code",
        "earth",
        "graphic",
        "music",
        "painting",
        "plant",
        "rocket",
        "scale",
        "search",
        "student",
        "syringe",
        "telescope",
        "wallclock"]

    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("icon", forIndexPath: indexPath) as! IconCollectionViewCell
        let imageName = images[indexPath.row]
        let image = UIImage(named: imageName)
        cell.iconName = imageName
        cell.iconButton.setBackgroundImage(image, forState: .Normal)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

}
