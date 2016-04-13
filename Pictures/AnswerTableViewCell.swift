//
//  AnswerTableViewCell.swift
//  Pictures
//
//  Created by 廖慶麟 on 2015/12/23.
//  Copyright © 2015年 廖慶麟. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    // MARK Properties
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionPhoto: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
