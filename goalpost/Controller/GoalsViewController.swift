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
let goalBackgroundColor = UIColor(red: 0x6D/255, green: 0xBC/255, blue: 0x63/255, alpha: 1.0)

// MARK: GoalsViewController
class GoalsViewController: UIViewController {

    // MARK: - Properties
    
    let titleView: UIView = {
        let titleView = UIView()
        let backgroundColor = goalBackgroundColor
        titleView.backgroundColor = backgroundColor
       
        return titleView
    }()
    
    let goalTitleTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "Georgia", size: 18.0)
        textLabel.textAlignment = .center
        textLabel.text = "GOAL"
        
        return textLabel
    }()
    
    let postTitleTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "Georgia-Bold", size: 18.0)
        textLabel.textAlignment = .center
        textLabel.text = "POST"
        
        return textLabel
    }()
    
    let goalCreationButton: UIButton = {
        let goalButton = UIButton()
        goalButton.setTitle("", for: .normal)
        goalButton.setImage(UIImage(named: "addGoal"), for: .normal)
        goalButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        goalButton.contentMode = .center
        goalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
       
        return goalButton
    }()
    
    let welcomeTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        textLabel.font = UIFont(name: "Georgia-Bold", size: 24.0)
        textLabel.textAlignment = .center
        textLabel.text = "Welcome to Goalpost"
        
        return textLabel
    }()
    
    let instructionTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        textLabel.font = UIFont(name: "Georgia-Italic", size: 14.0)
        textLabel.textAlignment = .center
        textLabel.text = "To begin, create a goal."
        
        return textLabel
    }()
    
    let goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.rowHeight = 70
        tableView.register(GoalCell.self, forCellReuseIdentifier: "goal cell")
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableHeaderView?.backgroundColor = .clear
        return tableView
    }()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Up and running")

        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        setupBackgroundView()
        setupTitleView()
        goalsTableView.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        
        //Title view pinlayout
        titleView.pin.top().left().right().marginBottom(10).height(70)
        
        //Goals TableView pinlayout
        goalsTableView.pin.left().right().bottom().top(to: titleView.edge.bottom)
        goalsTableView.tableHeaderView?.pin.left().right().height(10)
        
        //Title contents constraints
        goalTitleTextLabel.pin.topRight(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginBottom(12).width(60)
        postTitleTextLabel.pin.topLeft(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginBottom(12).width(60)
        goalCreationButton.pin.right().marginHorizontal(15).vCenter(to: goalTitleTextLabel.edge.vCenter).height(30).width(30)
        
        //Welcome tet label constraints
        welcomeTextLabel.pin.below(of: titleView).marginTop(50).left().right().height(30)
        instructionTextLabel.pin.below(of: welcomeTextLabel).left().right().height(30)
    }

    // MARK: - Setup
    
    private func setupBackgroundView() {
        self.view.backgroundColor = .white
        
        //Add subview to root view
        self.view.addSubview(titleView)
        self.view.addSubview(welcomeTextLabel)
        self.view.addSubview(instructionTextLabel)
        self.view.addSubview(goalsTableView)
    }
    
    private func setupTitleView() {
        //Add labels and button to titleview
        titleView.addSubview(goalTitleTextLabel)
        titleView.addSubview(postTitleTextLabel)
        titleView.addSubview(goalCreationButton)
    }
    
    // MARK: - Button function
    
    @objc func goalButtonPressed( _ sender: UIButton) {
        
        let createGoalViewController = CreateGoalsViewController()
        presentDetail(createGoalViewController)
    }

}


//MARK: - TableView protocol functions

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goal cell") as? GoalCell else {
            return UITableViewCell() }
        cell.configureCell(description: "Eat salad twice a week", type: .shortTerm, goalProgressAmount: 99)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
}
