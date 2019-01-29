//
//  DeadlineTableViewCell.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/19/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit

class DeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var event: Event?
    var completionHandler: (() -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        completeButton.setImage(UIImage(named: "check_gray"), for: UIControl.State.disabled)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTableViewCell() {
        deadlineLabel.text = Event.localTime(forDate: event!.deadlineDate)
        if event!.isCompleted {
            completeButton.isEnabled = false
            if event!.prevDeadlineDate.timeIntervalSinceNow < 0 {
                availableLabel.text = "Now"
            } else {
                availableLabel.text = Event.localTime(forDate: event!.prevDeadlineDate)
            }
        } else {
            completeButton.isEnabled = true
            availableLabel.text = "Now"
        }
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        completionHandler()
    }
    

}
