//
//  categoryTableViewCell.swift
//  GradeUp
//
//  Created by Adrien morel on 2/9/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
}
