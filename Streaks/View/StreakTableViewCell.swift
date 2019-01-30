//
//  StreakTableViewCell.swift
//  Streaks
//
//  Created by Chris Aguilera on 9/19/18.
//  Copyright © 2018 Chris Aguilera. All rights reserved.
//

import UIKit

class StreakTableViewCell: UITableViewCell {

    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var bestStreakLabel: UILabel!
    @IBOutlet weak var completionRateLabel: UILabel!
    @IBOutlet weak var streakProgressView: UIProgressView!
    @IBOutlet weak var completionProgressView: UIProgressView!
    
    var event: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTableViewCell() {
        currentStreakLabel.text = String(event!.currentStreak)
        bestStreakLabel.text = String(event!.bestStreak)
        
        // If completionRate is whole number remove decimal places
        let stringValue = (event!.completionRate * 100) == floor(event!.completionRate * 100) ? String(format: "%.0f", event!.completionRate * 100) : String(format: "%.2f", event!.completionRate * 100)
        completionRateLabel.text = stringValue + "%"
        
        if event!.totalNum == 0 {
            streakProgressView.setProgress(0.0, animated: false)
            completionProgressView.setProgress(0.0, animated: false)
        } else {
            streakProgressView.setProgress(Float(event!.currentStreak)/Float(event!.bestStreak), animated: false)
            completionProgressView.setProgress(Float(event!.completionRate), animated: false)
        }
    }

}
