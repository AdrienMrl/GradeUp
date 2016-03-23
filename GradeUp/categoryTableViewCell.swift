//
//  categoryTableViewCell.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var questionsNumber: UILabel!
    var onIconTap: ((Int) -> ())?
    var index: Int!

    override func awakeFromNib() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(categoryTableViewCell.iconTap(_:)))
        icon.userInteractionEnabled = true
        icon.addGestureRecognizer(tapGR)
        
        nameTextField.delegate = self
    }
    
    func iconTap(tg: UITapGestureRecognizer?) {
        onIconTap?(index)
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
    
    func setQuestionsCount(count: Int) {
        
        let questions = count == 0 ? "question" : "questions"
        
        questionsNumber.text = "\(count) \(questions)"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }

}
