//
//  ScoreViewController.swift
//  Tony2048
//
//  Created by Anthony Latsis on 18.04.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import UIKit

protocol ScoreViewControllerType: SubviewControllerType {
    
    var scoreLabel: UILabel { get }
    var scoreTitleLabel: UILabel { get }
    
    init(scoreLabel: UILabel, scoreTitleLabel: UILabel)

    func settingsForScoreLabel()
    func settingsForScoreTitleLabel()
    
    var viewBackgroundColor: UIColor { get }
    var scoreLabelsColor: UIColor { get }
}

final class ScoreViewController: UIViewController, ScoreViewControllerType {
    
    // MARK: constants
    
    let scoreLabel: UILabel
    let scoreTitleLabel: UILabel
    
    let viewBackgroundColor = UIColor(red: 133/255.0, green: 134/255.0, blue: 131/255.0, alpha: 1.0)
    let scoreLabelsColor    = UIColor(red: 243/255.0, green: 248/255.0, blue: 238/255.0, alpha: 1.0)
    
    // MARK: init methods
    
    required init(scoreLabel: UILabel, scoreTitleLabel: UILabel) {
        self.scoreLabel = scoreLabel
        self.scoreTitleLabel = scoreTitleLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsForView()
        settingsForScoreLabel()
        settingsForScoreTitleLabel()
        
        GlobalMethodsClass.addObjectsToView([scoreTitleLabel, scoreLabel], toView: view)
        
        NSLayoutConstraint.activateConstraints([
            scoreTitleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            scoreTitleLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 7.0),
            scoreLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            scoreLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -7.0)
            ])
    }
    
    override func viewWillLayoutSubviews() {
        //add code
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setConstraintsForView(inSuperview superViewController: AnyObject) {
        if let viewController = superViewController as? ViewController, mainController = viewController.mainFieldController as? MainFieldController {
            NSLayoutConstraint.activateConstraints([
                view.bottomAnchor.constraintEqualToAnchor(mainController.view.topAnchor, constant: -50.0),
                view.rightAnchor.constraintEqualToAnchor(viewController.view.rightAnchor, constant: -10.0),
                view.widthAnchor.constraintEqualToConstant(140.0),
                view.heightAnchor.constraintEqualToConstant(70.0)
                ])
        }
    }
    
    func settingsForScoreTitleLabel() {
        scoreTitleLabel.backgroundColor = viewBackgroundColor
        scoreTitleLabel.font = scoreLabel.font.fontWithSize(20.0)
        scoreTitleLabel.text = "score"
        scoreTitleLabel.textColor = scoreLabelsColor
    }
    
    func settingsForScoreLabel() {
        scoreLabel.backgroundColor = viewBackgroundColor
        scoreLabel.font = scoreTitleLabel.font.fontWithSize(22.0)
        scoreLabel.text = "0"
        scoreLabel.textColor = scoreLabelsColor
    }
    
    func settingsForView() {
        view.backgroundColor = viewBackgroundColor
        view.layer.cornerRadius = 6.0
    }
    
    // MARK: helper methods
    
    func updateScore(by number: Int) {
        scoreLabel.text = "\(Int(scoreLabel.text!)! + number)"
    }
    
    func resetScore() {
        scoreLabel.text = "0"
    }
}
