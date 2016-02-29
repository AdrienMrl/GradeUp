//
//  categoryTableViewCell.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var questionsNumber: UILabel!
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //icon.backgroundColor = UIColor.blueColor()
        //icon.layer.cornerRadius = icon.frame.size.width / 2
        //icon.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEditable(state: Bool) {
        nameTextField.userInteractionEnabled = state
    }

    func setCategoryName(name: String) {
        nameTextField.text = name
    }
    
    func getCategoryName() -> String {
        return nameTextField.text ?? "empty"
    }
    
    func setQuestionsCount(count: Int) {
        
        let questions = count == 0 ? "question" : "questions"
        
        questionsNumber.text = "\(count) \(questions)"
    }
}
