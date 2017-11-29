//
//  GoalsViewController.swift
//  goalpost
//
//  Created by Hammoud Hammoud on 11/21/17.
//  Copyright © 2017 Hammoud Hammoud. All rights reserved.
//

import UIKit
import PinLayout
import CoreData

// MARK: Constants
let appDelegate = UIApplication.shared.delegate as? AppDelegate
let screenSize = UIScreen.main.bounds
let statusBarSize = UIApplication.shared.statusBarFrame.size
let goalBackgroundColor = UIColor(red: 0x6D/255, green: 0xBC/255, blue: 0x63/255, alpha: 1.0)


// MARK: GoalsViewController
class GoalsViewController: UIViewController {

    // MARK: - Properties
    
    var goals: [Goal] = []
    var lastDeletedGoalText: [String : String] = [:]
    var lastDeletedGoalNumbers: [String : Int32] = [:]
    
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

    let undoView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        view.alpha = 0
        
        return view
    }()
    
    let undoLabel: UILabel = {
        let label = UILabel()
        label.text = "Goal Removed"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Georgia-Bold", size: 16)
        
        return label
    }()
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UNDO", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        setupBackgroundView()
        setupTitleView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        goalsTableView.reloadData()
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
        
        //Welcome text label constraints
        welcomeTextLabel.pin.below(of: titleView).marginTop(50).left().right().height(30)
        instructionTextLabel.pin.below(of: welcomeTextLabel).left().right().height(30)
        
        //Undo View
        undoView.pin.bottom().right().left().height(55)
        undoLabel.pin.left().top().bottom().right(to: undoView.edge.hCenter).marginHorizontal(10)
        undoButton.pin.right().top().bottom().width(70).marginHorizontal(10).marginVertical(10)
    }
    
    // MARK: - Button function
    
    @objc func goalButtonPressed( _ sender: UIButton) {
        
        let createGoalViewController = CreateGoalsViewController()
        presentDetail(createGoalViewController)
    }
    
    @objc func undoButtonPressed(_ sender: UIButton) {
        //Undo the deletion
        //Method 1 - Cache the data when deleted and restore it when button is pressed
//        if !lastDeletedGoalNumbers.isEmpty && !lastDeletedGoalText.isEmpty {
//            resaveData(deletedGoalText: lastDeletedGoalText, deletedGoalNumbers: lastDeletedGoalNumbers, completion: { (completed) in
//                fetchCoreDataObjects()
//                self.goalsTableView.reloadData()
//                self.lastDeletedGoalNumbers = [:]
//                self.lastDeletedGoalText = [:]
//            })
//        }
        
        //Method 2 - Use core data's undo (Much simpler)
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.undoManager?.undo()
        fetchCoreDataObjects()
        goalsTableView.reloadData()
    }
    
    //MARK: - Helper functions
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    goalsTableView.isHidden = false
                }
                else {
                    goalsTableView.isHidden = true
                }
            }
        }
    }
    
    private func setupBackgroundView() {
        self.view.backgroundColor = .white
        
        //Add subview to root view
        self.view.addSubview(titleView)
        self.view.addSubview(welcomeTextLabel)
        self.view.addSubview(instructionTextLabel)
        self.view.addSubview(goalsTableView)
        self.view.addSubview(undoView)
        
        undoView.addSubview(undoLabel)
        undoView.addSubview(undoButton)
    }
    
    private func setupTitleView() {
        //Add labels and button to titleview
        titleView.addSubview(goalTitleTextLabel)
        titleView.addSubview(postTitleTextLabel)
        titleView.addSubview(goalCreationButton)
    }
    

}


//MARK: - TableView protocol functions

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goal cell") as? GoalCell else {
            return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            //Delete

            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.showUndoView(undoView: self.undoView)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        addAction.backgroundColor = nextButtonColor
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction, addAction]
    }
    
    //Following two functions are used to create space between table sections
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 1))
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
}

//MARK: - Core Data functions

extension GoalsViewController {
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        lastDeletedGoalText["description"] = goals[indexPath.row].goalDescription
        lastDeletedGoalText["type"] = goals[indexPath.row].goalType
        lastDeletedGoalNumbers["progress"] = goals[indexPath.row].goalProgressValue
        lastDeletedGoalNumbers["completion"] = goals[indexPath.row].goalCompletionValue
        
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
        
    }
    
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgressValue < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgressValue += 1
        }
        else {
            return
        }
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    func showUndoView(undoView: UIView) {

        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            undoView.alpha = 1
        }, completion: nil)
        let when = DispatchTime.now() + 10
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                undoView.alpha = 0
            }, completion: nil)
        }
    }
    
    func resaveData(deletedGoalText: [String : String], deletedGoalNumbers: [String : Int32], completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = deletedGoalText["description"]
        goal.goalType = deletedGoalText["type"]
        
        guard let deletedGoalCompletion = deletedGoalNumbers["completion"] else { return }
        guard let deletedGoalProgress = deletedGoalNumbers["progress"] else { return }
     
        goal.goalCompletionValue = deletedGoalCompletion
        goal.goalProgressValue = deletedGoalProgress
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not retrieve deleted goal: \(error.localizedDescription)")
            completion(false)
        }
    }
}
