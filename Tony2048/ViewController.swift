//
//  ViewController.swift
//  Tony2048
//
//  Created by Anthony Latsis on 17.04.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: constants
    
    var scoreViewController: ScoreViewControllerType
    var mainFieldController: CellViewControllerType

    let nameLabel = UILabel()
    let undoButton = UIButton()
    let newGameButton = UIButton()

    let mainCornerRadius: CGFloat = 6.0
    
    let mainFieldColor = UIColor(red: 133/255.0, green: 134/255.0, blue: 131/255.0, alpha: 1.0)
    let labelTextColor = UIColor(red: 243/255.0, green: 248/255.0, blue: 238/255.0, alpha: 1.0)
    let nameLabelColor = UIColor(red: 81/255.0 , green: 81/255.0 , blue: 80/255.0 , alpha: 1.0)
    
    required init?(coder aDecoder: NSCoder) {
        scoreViewController = ScoreViewController(scoreLabel: UILabel(), scoreTitleLabel: UILabel())
        mainFieldController = MainFieldController(rowQuantity: 4)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        let scoreController = scoreViewController as! ScoreViewController
        let mainController = mainFieldController as! MainFieldController
        
        mainController.scoreViewController = scoreViewController as? ScoreViewController
    
        GlobalMethodsClass.addObjectsToView([mainController.view, scoreController.view, nameLabel, undoButton, newGameButton], toView: view)
        
        settingsForNameLabel()
        customizeButton(undoButton, title: "undo")
        customizeButton(newGameButton, title: "reset")
        
        newGameButton.addTarget(self, action: #selector(ViewController.didPressResetButton(_:)), forControlEvents: .TouchUpInside)
        
        scoreViewController.setConstraintsForView(inSuperview: self)
        mainFieldController.setConstraintsForView(inSuperview: self)

        NSLayoutConstraint.activateConstraints([
            nameLabel.bottomAnchor.constraintEqualToAnchor(mainController.view.topAnchor, constant: -50.0),
            nameLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10.0),
            nameLabel.heightAnchor.constraintEqualToConstant(80.0),
            undoButton.heightAnchor.constraintEqualToConstant(40.0),
            undoButton.widthAnchor.constraintEqualToConstant(65.0),
            undoButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10.0),
            undoButton.bottomAnchor.constraintEqualToAnchor(mainController.view.topAnchor, constant: -5.0),
            newGameButton.heightAnchor.constraintEqualToConstant(40.0),
            newGameButton.widthAnchor.constraintEqualToConstant(65.0),
            newGameButton.rightAnchor.constraintEqualToAnchor(undoButton.leftAnchor, constant: -10),
            newGameButton.bottomAnchor.constraintEqualToAnchor(mainController.view.topAnchor, constant: -5.0)
            ])
    }
    
    override func viewWillLayoutSubviews() {
        //add code
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func settingsForNameLabel() {
        nameLabel.backgroundColor = .whiteColor()
        nameLabel.font = nameLabel.font.fontWithSize(55.0)
        nameLabel.textColor = nameLabelColor
        nameLabel.textAlignment = .Center
        nameLabel.text = "2048"
    }
    
    func customizeButton(button: UIButton, title: String) {
        button.backgroundColor = mainFieldColor
        button.setTitleColor(labelTextColor, forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.tintColor = .whiteColor()
        button.titleLabel?.font = button.titleLabel?.font.fontWithSize(17.0)
        button.layer.cornerRadius = 7.0
        
    }
    
    func didPressResetButton(sender: UIButton) {
        UIButton.animateWithDuration(0.1) {
            sender.setTitleColor(.whiteColor(), forState: .Normal)
            sender.setTitleColor(self.labelTextColor, forState: .Normal)
            self.view.layoutIfNeeded()
        }
        let mainController = mainFieldController as! MainFieldController
        
        mainController.startNewGame()
    }
}




