//
//  GoalsViewController.swift
//  goalpost
//
//  Created by Hammoud Hammoud on 11/21/17.
//  Copyright © 2017 Hammoud Hammoud. All rights reserved.
//

import UIKit
import PinLayout

// MARK: Constants
let screenSize = UIScreen.main.bounds
let statusBarSize = UIApplication.shared.statusBarFrame.size

// MARK: GoalsViewController
class GoalsViewController: UIViewController {

    // MARK: - Properties
    
    let titleView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 70))
        titleView.translatesAutoresizingMaskIntoConstraints = false
        let backgroundColor = UIColor(red: 0x6D/255, green: 0xBC/255, blue: 0x63/255, alpha: 1.0)
        titleView.backgroundColor = backgroundColor
       
        return titleView
    }()
    
    let goalsTableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 80, width: screenSize.width, height: 300))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.rowHeight = 70
        return tableView
    }()
    
    let goalTableCell : UITableViewCell = {
        let prototypeCell = UITableViewCell(frame: CGRect(x: screenSize.width/2, y: screenSize.height/2, width: screenSize.width, height: 100))
        prototypeCell.backgroundColor = .red
        print("Prototype bounds: \(prototypeCell.bounds)")
        
        //Text label: "Goal:"
        let goalTextLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 20))
        
        //
        goalTextLabel.backgroundColor = .white
        //
        
        goalTextLabel.text = "Goal:"
        goalTextLabel.font = UIFont(name: "Georgia-Bold", size: 18)
        prototypeCell.addSubview(goalTextLabel)
        goalTextLabel.pin.top().margin(5).topLeft()
        
        //Text label which describes the goal
        let goalDescriptionLabel = UILabel(frame: CGRect(x: 11, y: 11, width: 50, height: 20))
        goalDescriptionLabel.text = "Example goal inserted here, will populate with user data"
        goalDescriptionLabel.font = UIFont(name: "Georgia-Bold", size: 18)
        goalDescriptionLabel.adjustsFontSizeToFitWidth = true
        goalDescriptionLabel.minimumScaleFactor = 0.5
        goalDescriptionLabel.numberOfLines = 2
        goalDescriptionLabel.lineBreakMode = .byWordWrapping
        prototypeCell.addSubview(goalDescriptionLabel)

        //Text label: "Type:"
        let typeTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        
        //
        typeTextLabel.backgroundColor = .blue
        //
        
        typeTextLabel.text = "Type:"
        typeTextLabel.font = UIFont(name: "Georgia", size: 14)
        prototypeCell.addSubview(typeTextLabel)
        typeTextLabel.pin.below(of: goalTextLabel, aligned: .left).bottom().marginRight(5)
        
        //Text label which denotes whether the goal is short- or long-term
        let typeDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width - 100, height: 25))
        typeDescriptionLabel.text = "Short-Term"
        typeDescriptionLabel.font = UIFont(name: "Georgia", size: 14)
        prototypeCell.addSubview(typeDescriptionLabel)
        typeDescriptionLabel.pin.after(of: typeTextLabel).bottom()
        
        //Text label denoting how many weeks/days/hours left until goal is finished as a whole number
        let timeRemainingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
        
        //
        timeRemainingLabel.backgroundColor = .blue
        //
        
        timeRemainingLabel.text = "9"
        timeRemainingLabel.font = UIFont(name: "Georgia-Bold", size: 24)
        //Same color as the title background
        timeRemainingLabel.textColor = UIColor(red: 0x6D/255, green: 0xBC/255, blue: 0x63/255, alpha: 1.0)
        timeRemainingLabel.textAlignment = .center
        timeRemainingLabel.adjustsFontSizeToFitWidth = true
        timeRemainingLabel.minimumScaleFactor = 0.5
        prototypeCell.addSubview(timeRemainingLabel)
        timeRemainingLabel.pin.right().vCenter()
        goalDescriptionLabel.pin.topLeft(to: goalTextLabel.anchor.topRight)
        typeDescriptionLabel.pin.topLeft(to: typeTextLabel.anchor.topRight)
        return prototypeCell
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Up and running")
        setupBackgroundView()
        setupTitleView()
        setupWelcomeLabels()
    }
    
    override func viewDidLayoutSubviews() {
        //Title view pinlayout
        titleView.pin.top().left().right().marginBottom(10).sizeToFit(.width)
        titleView.pin.maxHeight(70).minHeight(70)
        
        //Goals TableView pinlayout
        goalsTableView.pin.below(of: titleView).left().right().bottom().top(to: titleView.edge.bottom)
        
        //Title labels pinlayout
        titleView.subviews[0].pin.topRight(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginHorizontal(0).marginBottom(12)
        titleView.subviews[1].pin.topLeft(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginHorizontal(0).marginBottom(12)
        titleView.subviews[2].pin.right().marginHorizontal(8).vCenter(to: titleView.subviews[0].edge.vCenter).marginBottom(2)
        
        //Adding prototypecell
        print("Adding prototype cell")
        self.view.addSubview(goalTableCell)
        goalTableCell.pin.vCenter().hCenter()

    }

    // MARK: - Setup
    
    private func setupBackgroundView() {
        self.view.backgroundColor = .white
        
        //Add subview to root view
        self.view.addSubview(titleView)
        self.view.addSubview(goalsTableView)
    }
    
    private func setupTitleView() {
        
        //Create text labels
        let goalTitleTextLabel : UILabel = {
           let textLabel = UILabel(frame: CGRect(x: 0, y: 25, width: 60, height: 25))
            textLabel.translatesAutoresizingMaskIntoConstraints = true
            textLabel.textColor = .white
            textLabel.font = UIFont(name: "Georgia", size: 18.0)
            textLabel.textAlignment = .center
            textLabel.text = "GOAL"
            
            return textLabel
        }()
        let postTitleTextLabel : UILabel = {
            let textLabel = UILabel(frame: CGRect(x: 50, y: 25, width: 60, height: 25))
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.textColor = .white
            textLabel.font = UIFont(name: "Georgia-Bold", size: 18.0)
            textLabel.textAlignment = .center
            textLabel.text = "POST"
            
            return textLabel
        }()
        
        //Create button
        let goalCreationButton : UIButton = {
            let goalButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            goalButton.translatesAutoresizingMaskIntoConstraints = false
            goalButton.setTitle("", for: .normal)
            goalButton.setImage(UIImage(named: "addGoal"), for: .normal)
            goalButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            goalButton.contentMode = .center
            goalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
            return goalButton
        }()

        //Add labels and button to titleview
        titleView.addSubview(goalTitleTextLabel)
        titleView.addSubview(postTitleTextLabel)
        titleView.addSubview(goalCreationButton)
        
        //Setup constraints
//        goalTitleTextLabel.pin.topRight(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginHorizontal(0).marginBottom(12)
//        postTitleTextLabel.pin.topLeft(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginHorizontal(0).marginBottom(12)
//        goalCreationButton.pin.right().marginHorizontal(8).vCenter(to: goalTitleTextLabel.edge.vCenter).marginBottom(2)
        
    }
    
    private func setupWelcomeLabels() {
        
        let welcomeTextLabel : UILabel = {
            let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            textLabel.font = UIFont(name: "Georgia-Bold", size: 24.0)
            textLabel.textAlignment = .center
            textLabel.text = "Welcome to Goalpost"
            
            return textLabel
        }()
        let instructionTextLabel : UILabel = {
            let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            textLabel.font = UIFont(name: "Georgia-Italic", size: 14.0)
            textLabel.textAlignment = .center
            textLabel.text = "To begin, create a goal."
            
            return textLabel
        }()
        
        self.view.addSubview(welcomeTextLabel)
        self.view.addSubview(instructionTextLabel)
        
        welcomeTextLabel.pin.below(of: titleView, aligned: .center).marginTop(50)
        instructionTextLabel.pin.below(of: welcomeTextLabel, aligned: .center)
    }

    // MARK: - Button and TableView functions
    
    @IBAction func goalButtonPressed( _ sender: UIButton) {
        print("IT WORKS!")
    }

}

