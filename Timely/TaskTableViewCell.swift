//
//  TaskTableViewCell.swift
//  Assignment1_ToDo
//
//  Created by 张泽正 on 2019/4/13.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
