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
        let prototypeCell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: tableView.rowHeight))
        tableView.addSubview(prototypeCell)
        return tableView
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

