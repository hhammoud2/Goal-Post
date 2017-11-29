//
//  GoalCell.swift
//  goalpost
//
//  Created by Hammoud Hammoud on 11/27/17.
//  Copyright © 2017 Hammoud Hammoud. All rights reserved.
//

import UIKit
import PinLayout

class GoalCell: UITableViewCell {

    //MARK: - Properties
    
    let goalDescriptionLabel: UILabel = {
        let goalDescriptionLabel = UILabel()
        goalDescriptionLabel.text = "Example goal inserted here, will populate with user data"
        goalDescriptionLabel.font = UIFont(name: "Georgia", size: 14)
        goalDescriptionLabel.baselineAdjustment = .alignCenters
        goalDescriptionLabel.adjustsFontSizeToFitWidth = true
        goalDescriptionLabel.minimumScaleFactor = 0.5
        goalDescriptionLabel.numberOfLines = 2
        goalDescriptionLabel.lineBreakMode = .byWordWrapping
        return goalDescriptionLabel
    }()
    
    let typeDescriptionLabel: UILabel = {
        let typeDescriptionLabel = UILabel()
        typeDescriptionLabel.text = "Short-Term"
        typeDescriptionLabel.font = UIFont(name: "Georgia", size: 14)
        return typeDescriptionLabel
    }()
    
    let timeRemainingLabel: UILabel = {
        let timeRemainingLabel = UILabel()
        timeRemainingLabel.text = "9"
        timeRemainingLabel.font = UIFont(name: "Georgia-Bold", size: 24)
        timeRemainingLabel.textColor = goalBackgroundColor
        timeRemainingLabel.textAlignment = .center
        timeRemainingLabel.adjustsFontSizeToFitWidth = true
        timeRemainingLabel.minimumScaleFactor = 0.5
        return timeRemainingLabel
    }()
    
    let goalLabel : UILabel = {
        let label = UILabel()
        label.text = "Goal:"
        label.font = UIFont(name: "Georgia-Bold", size: 18)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type:"
        label.font = UIFont(name: "Georgia", size: 14)
        return label
    }()
    
    let completionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x2C/255, green: 0x67/255, blue: 0x00/255, alpha: 0.80)
        view.isHidden = false
        
        return view
    }()
    
    let goalCompleteLabel: UILabel = {
        let label = UILabel()
        label.text = "GOAL COMPLETE!!"
        label.font = UIFont(name: "Georgia-Bold", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    
    //MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        contentView.addSubview(goalLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(goalDescriptionLabel)
        contentView.addSubview(typeDescriptionLabel)
        contentView.addSubview(timeRemainingLabel)
        contentView.addSubview(completionView)
        
        completionView.addSubview(goalCompleteLabel)
        
        layoutSubviews()
    }
    
    //MARK: - Functions
    
    func configureCell(goal: Goal) {
        goalDescriptionLabel.text = goal.goalDescription
        typeDescriptionLabel.text = goal.goalType
        timeRemainingLabel.text = String(goal.goalProgressValue)
        
        if goal.goalProgressValue == goal.goalCompletionValue {
            self.completionView.isHidden = false
        }
        else {
            self.completionView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        goalLabel.pin.margin(5).topLeft().height(25).width(50).marginTop(10)
        typeLabel.pin.below(of: goalLabel, aligned: .left).marginTop(10).height(15).width(40)
        timeRemainingLabel.pin.top().bottom().right().width(40).marginRight(10)
        goalDescriptionLabel.pin.after(of: goalLabel, aligned: .center).before(of: timeRemainingLabel).height(40).marginHorizontal(5)
        typeDescriptionLabel.pin.centerLeft(to: typeLabel.anchor.centerRight).height(25).width(75)
        completionView.pin.top().bottom().left().right()
        goalCompleteLabel.pin.top().bottom().marginVertical(10).width(300).hCenter()
    }
}
