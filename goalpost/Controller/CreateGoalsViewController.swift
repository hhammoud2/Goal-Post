//
//  CreateGoalsViewController.swift
//  goalpost
//
//  Created by Hammoud Hammoud on 11/28/17.
//  Copyright © 2017 Hammoud Hammoud. All rights reserved.
//

import UIKit
import PinLayout

let lightGoalBackgroundColor = UIColor(red: 0xB2/255, green: 0xDD/255, blue: 0xAF/255, alpha: 1.0)
let nextButtonColor = UIColor(red: 0x2C/255, green: 0x67/255, blue: 0x00/255, alpha: 1.0)

// MARK: CreateGoalsViewController
class CreateGoalsViewController: UIViewController {

    // MARK: - Properties
    
    var goalType: GoalType = .shortTerm
    
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
    
    let goalTextView: UITextView = {
       let textView = UITextView()
        textView.text = "What is your goal?"
        textView.font = UIFont(name: "Georgia", size: 18)
        textView.textColor = .lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 5
        
        return textView
    }()
    
    let selectOneLabel: UILabel = {
        let label = UILabel()
        label.text = "Select One:"
        label.font = UIFont(name: "Georgia", size: 14)
        label.textColor = .darkGray
        
        return label
    }()
    
    let shortTermButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SHORT TERM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = goalBackgroundColor
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 14)
        button.addTarget(self, action: #selector(shortTermButtonPressed), for: .touchUpInside)

        return button
    }()
    
    let longTermButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LONG TERM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = lightGoalBackgroundColor
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 14)
        button.addTarget(self, action: #selector(longTermButtonPressed), for: .touchUpInside)

        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 20)
        button.backgroundColor = nextButtonColor
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()

    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupTitleView()
        nextButton.bindToKeyboard()
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
        goalTextView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        
        //Title view pinlayout
        titleView.pin.top().left().right().marginBottom(10).height(70)
        
        //Title contents constraints
        goalTitleTextLabel.pin.topRight(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginBottom(12).width(60)
        postTitleTextLabel.pin.topLeft(to: titleView.anchor.center).bottom(to: titleView.edge.bottom).marginBottom(12).width(60)
        backButton.pin.left().marginHorizontal(15).vCenter(to: goalTitleTextLabel.edge.vCenter).height(30).width(30)
        
        //Text view constraints
        goalTextView.pin.below(of: titleView).right().left().height(175).marginHorizontal(20).marginTop(5).marginBottom(10)
        selectOneLabel.pin.below(of: goalTextView).right().left().height(15).marginVertical(10).marginHorizontal(20)
        shortTermButton.pin.below(of: selectOneLabel).left().right(to: goalTextView.edge.hCenter).height(60).marginLeft(20).marginRight(10).marginVertical(10)
        longTermButton.pin.below(of: selectOneLabel).right().left(to: goalTextView.edge.hCenter).height(60).marginRight(20).marginLeft(10).marginVertical(10)
        nextButton.pin.bottom().right().left().height(50)
    }
    
    // MARK: - Setup
    
    private func setupBackgroundView() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleView)
        self.view.addSubview(goalTextView)
        self.view.addSubview(selectOneLabel)
        self.view.addSubview(shortTermButton)
        self.view.addSubview(longTermButton)
        self.view.addSubview(nextButton)
    }
    
    private func setupTitleView() {
        //Add labels and button to titleview
        titleView.addSubview(goalTitleTextLabel)
        titleView.addSubview(postTitleTextLabel)
        titleView.addSubview(backButton)
    }
    
    // MARK: - Button/Touch functions
    
    @objc func backButtonPressed( _ sender: UIButton) {
        dismissDetail()
    }
    
    @objc func shortTermButtonPressed( _ sender: UIButton) {
        goalType = .shortTerm
        self.view.endEditing(true)
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @objc func longTermButtonPressed( _ sender: UIButton) {
        goalType = .longTerm
        self.view.endEditing(true)
        longTermButton.setSelectedColor()
        shortTermButton.setDeselectedColor()
    }
    
    @objc func nextButtonPressed( _ sender: UIButton) {
        self.view.endEditing(true)
        if goalTextView.text != "" && goalTextView.text != "What is your goal?" {
            let finishGoalViewController = FinishGoalViewController()
            finishGoalViewController.initData(description: goalTextView.text, type: goalType)
        presentingViewController?.presentSecondaryDetail(finishGoalViewController)
        }


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
}

extension CreateGoalsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if goalTextView.text == "" {
            goalTextView.text = "What is your goal?"
            goalTextView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
