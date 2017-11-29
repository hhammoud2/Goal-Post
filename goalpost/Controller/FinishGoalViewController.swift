//
//  FInishGoalViewController.swift
//  goalpost
//
//  Created by Hammoud Hammoud on 11/28/17.
//  Copyright © 2017 Hammoud Hammoud. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalViewController: UIViewController {

    //MARK: - Properties
    
    var goalDescription: String!
    var goalType: GoalType!
    let maxCompletionPoints = 99
    
    let titleView: UIView = {
        let titleView = UIView()
        let backgroundColor = UIColor(red: 0x6D/255, green: 0xBC/255, blue: 0x63/255, alpha: 1.0)
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
    
    let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        backButton.contentMode = .center
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return backButton
    }()
    
    let createGoalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CREATE GOAL", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 20)
        button.backgroundColor = nextButtonColor
        button.addTarget(self, action: #selector(createGoalButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "How many points to complete?"
        label.font = UIFont(name: "Georgia", size: 20)
        label.textAlignment = .center
        
        return label
    }()
    let pointsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = UIFont(name: "Georgia", size: 50)
        textField.textColor = goalBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 32
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundView()
        setupTitleView()
        createGoalButton.bindToKeyboard()
        pointsTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        
        //Title view pinlayout
        titleView.pin.top().left().right().marginBottom(10).height(70)
        
        //Title contents constraints
        goalTitleTextLabel.pin.topRight(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginBottom(12).width(60)
        postTitleTextLabel.pin.topLeft(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginBottom(12).width(60)
        backButton.pin.left().marginHorizontal(15).vCenter(to: goalTitleTextLabel.edge.vCenter).height(30).width(30)
        createGoalButton.pin.bottom().right().left().height(50)

        //Text field and questions
        questionLabel.pin.below(of: titleView).left().right().height(25).marginTop(20)
        pointsTextField.pin.below(of: questionLabel, aligned: .center).height(80).width(90).marginTop(20)
        
    }
    //MARK: - Setup
    
    private func setupBackgroundView() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleView)
        self.view.addSubview(createGoalButton)
        self.view.addSubview(questionLabel)
        self.view.addSubview(pointsTextField)
    }
    
    private func setupTitleView() {
        //Add labels and button to titleview
        titleView.addSubview(goalTitleTextLabel)
        titleView.addSubview(postTitleTextLabel)
        titleView.addSubview(backButton)
    }
    
    //MARK: - Data Functions
    
    func initData(description: String, type: GoalType) {
        goalDescription = description
        goalType = type
    }

    //MARK: - Button/Touch Functions
    
    @objc func createGoalButtonPressed( _ sender: UIButton) {
        self.view.endEditing(true)
        
        //Pass data in Core Data model
        if pointsTextField.text != "" {
            if Int(pointsTextField.text!)! > maxCompletionPoints {
                //Error must be less than 99
                let alert = UIAlertController(title: "Too many points!", message: "You must enter a value less than 100", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.saveData(completion: { (complete) in
                    if complete {
                        dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    @objc func backButtonPressed( _ sender: UIButton) {
        dismissDetail()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    func saveData(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        goal.goalProgressValue = Int32(0)
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}

extension FinishGoalViewController: UITextFieldDelegate {

}

