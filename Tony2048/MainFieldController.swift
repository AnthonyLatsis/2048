//
//  MainFieldController.swift
//  Tony2048
//
//  Created by Anthony Latsis on 19.04.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import UIKit
import GameKit

typealias Position = (x: Int, y: Int)
typealias CellView = (view: UIView, position: Position)
typealias CellLabel = (label: UILabel, position: Position, centerXAnchor: NSLayoutConstraint?, centerYAnchor: NSLayoutConstraint?)

protocol CellViewControllerType: SubviewControllerType {
    
    var cellViews: [CellView] { get }
    var cellLabels: [CellLabel] { get set }
    
    var rowQuantity: Int { get }
    
    var swipeUp: UISwipeGestureRecognizer { get }
    var swipeLeft: UISwipeGestureRecognizer { get }
    var swipeDown: UISwipeGestureRecognizer { get }
    var swipeRight: UISwipeGestureRecognizer { get }
    
    func didSwipeUp(gesture: UISwipeGestureRecognizer)
    func didSwipeDown(gesture: UISwipeGestureRecognizer)
    func didSwipeLeft(gesture: UISwipeGestureRecognizer)
    func didSwipeRight(gesture: UISwipeGestureRecognizer)
    
    init(rowQuantity: Int)
}

final class MainFieldController: UIViewController, CellViewControllerType {
  
    // MARK: constants and enums
    
    enum Number: Int {
        case TwoInThePowerOfOne    = 2
        case TwoInThePowerOfTwo    = 4
        case TwoInThePowerOfThree  = 8
        case TwoInThePowerOfFour   = 16
        case TwoInThePowerOfFive   = 32
        case TwoInThePowerOfSix    = 64
        case TwoInThePowerOfSeven  = 128
        case TwoInThePowerOfEight  = 256
        case TwoInThePowerOfNine   = 512
        case TwoInThePowerOfTen    = 1024
        case TwoInThePowerOfEleven = 2048
        
        var backgroundColor: UIColor {
            switch self {
            case .TwoInThePowerOfOne:
                return UIColor(red: 235/255.0, green: 241/255.0, blue: 230/255.0, alpha: 1.0)
            case .TwoInThePowerOfTwo:
                return UIColor(red: 233/255.0, green: 239/255.0, blue: 184/255.0, alpha: 1.0)
            case .TwoInThePowerOfThree:
                return UIColor(red: 238/255.0, green: 203/255.0, blue: 93/255.0, alpha: 1.0)
            case .TwoInThePowerOfFour:
                return UIColor(red: 234/255.0, green: 163/255.0, blue: 55/255.0, alpha: 1.0)
            case .TwoInThePowerOfFive:
                return UIColor(red: 234/255.0, green: 116/255.0, blue: 95/255.0, alpha: 1.0)
            case .TwoInThePowerOfSix:
                return UIColor(red: 234/255.0, green: 80/255.0, blue: 40/255.0, alpha: 1.0)
            case .TwoInThePowerOfSeven:
                return UIColor(red: 239/255.0, green: 221/255.0, blue: 89/255.0, alpha: 1.0)
            case .TwoInThePowerOfEight:
                return UIColor(red: 239/255.0, green: 231/255.0, blue: 63/255.0, alpha: 1.0)
            case .TwoInThePowerOfNine:
                return UIColor(red: 236/255.0, green: 224/255.0, blue: 0.0, alpha: 1.0)
            case .TwoInThePowerOfTen:
                return UIColor(red: 1.0, green: 253/255.0, blue: 0.0, alpha: 1.0)
            case .TwoInThePowerOfEleven:
                return UIColor(red: 1.0, green: 223/255.0, blue: 0.0, alpha: 1.0)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .TwoInThePowerOfOne, .TwoInThePowerOfTwo:
                return UIColor(red: 42/255.0, green: 43/255.0, blue: 42/255.0, alpha: 1.0)
            default:
                return UIColor.whiteColor()
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .TwoInThePowerOfEight, .TwoInThePowerOfNine:
                return 35.0
            case .TwoInThePowerOfTen, .TwoInThePowerOfEleven:
                return 30.0
            default: return 40.0
            }
        }
        
        static func returnDoubleValueCase(number: Int) -> Number {
            switch number {
            case Number.TwoInThePowerOfOne.rawValue: return .TwoInThePowerOfTwo
            case Number.TwoInThePowerOfTwo.rawValue: return .TwoInThePowerOfThree
            case Number.TwoInThePowerOfThree.rawValue: return .TwoInThePowerOfFour
            case Number.TwoInThePowerOfFour.rawValue: return .TwoInThePowerOfFive
            case Number.TwoInThePowerOfFive.rawValue: return .TwoInThePowerOfSix
            case Number.TwoInThePowerOfSix.rawValue: return .TwoInThePowerOfSeven
            case Number.TwoInThePowerOfSeven.rawValue: return .TwoInThePowerOfEight
            case Number.TwoInThePowerOfEight.rawValue: return .TwoInThePowerOfNine
            case Number.TwoInThePowerOfNine.rawValue: return .TwoInThePowerOfTen
            case Number.TwoInThePowerOfTen.rawValue: return .TwoInThePowerOfEleven
            default: fatalError()
            }
        }
    }
    
    var scoreViewController: ScoreViewController?
    
    var cellViews: [CellView]
    var cellLabels: [CellLabel]
    
    let rowQuantity: Int
    
    var somethingDidMove: Bool = false
    
    var swipeUp    = UISwipeGestureRecognizer()
    var swipeDown  = UISwipeGestureRecognizer()
    var swipeLeft  = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    
    let viewBackgroundColor = UIColor(red: 133/255.0, green: 134/255.0, blue: 131/255.0, alpha: 1.0)
    let cellColor           = UIColor(red: 205/255.0, green: 208/255.0, blue: 202/255.0, alpha: 1.0)

    
    // MARK: init methods
    
    required init(rowQuantity: Int) {
        cellViews = []
        for number in 0..<rowQuantity {
            for anotherNumber in 0..<rowQuantity {
                cellViews.append((UIView(), (number, anotherNumber)))
            }
        }
        cellLabels = []
        self.rowQuantity = rowQuantity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsForView()
        addCellSubviews()
        setConstraintsForCellViews()
        commonSettingsForCellViews()
        
        GlobalMethodsClass.addObjectsToView([swipeUp, swipeLeft, swipeDown, swipeRight], toView: view)
        
        swipeRight.direction = .Right
        swipeDown.direction  = .Down
        swipeLeft.direction  = .Left
        swipeUp.direction    = .Up
        
        swipeUp.addTarget(self, action: #selector(MainFieldController.didSwipeUp(_:)))
        swipeDown.addTarget(self, action: #selector(MainFieldController.didSwipeDown(_:)))
        swipeLeft.addTarget(self, action: #selector(MainFieldController.didSwipeLeft(_:)))
        swipeRight.addTarget(self, action: #selector(MainFieldController.didSwipeRight(_:)))
            
        addLabelToRandomFreePosition()
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setInitialConstraintsForCellLabel(position: Position) {
        let cellView = cellViewInPosition(position).view
        
        guard let cellLabel = cellLabelInPosition(position) else {
            fatalError()
        }
        let centerX = cellLabel.label.centerXAnchor.constraintEqualToAnchor(cellView.centerXAnchor)
        let centerY = cellLabel.label.centerYAnchor.constraintEqualToAnchor(cellView.centerYAnchor)
        NSLayoutConstraint.activateConstraints([
            cellLabel.label.widthAnchor.constraintEqualToConstant(68.5),
            cellLabel.label.heightAnchor.constraintEqualToConstant(68.5),
            centerX, centerY
            ])
        let cellLabelIndex = getIndexOfLabel(inPosition: cellLabel.position)
        cellLabels[cellLabelIndex].centerXAnchor = centerX
        cellLabels[cellLabelIndex].centerYAnchor = centerY
    }
    
    func moveLabel(cellLabel: CellLabel, toPosition newPosition: Position, direction: UISwipeGestureRecognizerDirection, needToSet: Bool) {
        let destinationView = cellViewInPosition(newPosition).view
        let cellLabelIndex = getIndexOfLabel(inPosition: cellLabel.position)
        switch direction {
        case UISwipeGestureRecognizerDirection.Up, UISwipeGestureRecognizerDirection.Down:
            cellLabels[cellLabelIndex].position.y = newPosition.y
            cellLabels[cellLabelIndex].centerYAnchor!.active = false
            UILabel.animateWithDuration(0.1) {
                self.cellLabels[cellLabelIndex].centerYAnchor = cellLabel.label.centerYAnchor.constraintEqualToAnchor(destinationView.centerYAnchor)
                NSLayoutConstraint.activateConstraints([self.cellLabels[cellLabelIndex].centerYAnchor!])
                self.view.layoutIfNeeded()
            }
        case UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Right:
            cellLabels[cellLabelIndex].position.x = newPosition.x
            cellLabels[cellLabelIndex].centerXAnchor!.active = false
            UILabel.animateWithDuration(0.1) {
                self.cellLabels[cellLabelIndex].centerXAnchor = cellLabel.label.centerXAnchor.constraintEqualToAnchor(destinationView.centerXAnchor)
                NSLayoutConstraint.activateConstraints([self.cellLabels[cellLabelIndex].centerXAnchor!])
                self.view.layoutIfNeeded()
            }
        default: fatalError()
        }
        if needToSet == true {
            setLabel(cellLabel.label, number: Number.returnDoubleValueCase(Int(cellLabel.label.text!)!))
            scoreViewController?.updateScore(by: Int(cellLabel.label.text!)!)
        }
        somethingDidMove = true
    }
    
    func settingsForView() {
        view.backgroundColor = viewBackgroundColor
        view.layer.cornerRadius = 6.0
    }
    
    func setConstraintsForView(inSuperview superViewController: AnyObject) {
        if let viewController = superViewController as? ViewController {
            NSLayoutConstraint.activateConstraints([
                view.bottomAnchor.constraintLessThanOrEqualToAnchor(viewController.view.bottomAnchor, constant: -20.0),
                view.bottomAnchor.constraintGreaterThanOrEqualToAnchor(viewController.view.bottomAnchor, constant: -70.0),
                view.topAnchor.constraintLessThanOrEqualToAnchor(viewController.view.topAnchor, constant: 200.0),
                view.leftAnchor.constraintEqualToAnchor(viewController.view.leftAnchor, constant: 10.0),
                view.rightAnchor.constraintEqualToAnchor(viewController.view.rightAnchor, constant: -10.0),
                view.centerXAnchor.constraintEqualToAnchor(viewController.view.centerXAnchor),
                view.heightAnchor.constraintEqualToConstant(300.0),
                view.widthAnchor.constraintEqualToConstant(300.0)
                ])
        }
    }
    
    func commonSettingsForCellViews() {
        for cellView in cellViews {
            cellView.view.backgroundColor = cellColor
            cellView.view.layer.cornerRadius = 5.0
            NSLayoutConstraint.activateConstraints([
                cellView.view.heightAnchor.constraintEqualToConstant(68.5),
                cellView.view.widthAnchor.constraintEqualToConstant(68.5)
                ])
        }
    }
    
    func setConstraintsForCellViews() {
        for cellView in cellViews {
            setConstraintsForCellView(cellView.position)
        }
    }
    
    func mergeLabels(staticLabel: CellLabel, movingLabel: CellLabel, direction: UISwipeGestureRecognizerDirection) {
        staticLabel.label.removeFromSuperview()
        cellLabels.removeAtIndex(getIndexOfLabel(inPosition: staticLabel.position))
        moveLabel(movingLabel, toPosition: staticLabel.position, direction: direction, needToSet: true)
        
    }
    
    func didSwipeUp(gesture: UISwipeGestureRecognizer) {
        var number = 2
        while number >= 0 {
            for anotherNumber in 0...rowQuantity - 1 {
                guard let labelToBeMoved = cellLabelInPosition((anotherNumber, number)) else {
                    continue
                }
                var count = rowQuantity - 1
                while count >= labelToBeMoved.position.y {
                    if decideLabelAction(labelToBeMoved, gesture: gesture, count: count) {
                        break
                    }
                    count -= 1
                }
            }
            number -= 1
        }
        checkIfSomethingDidMove()
    }

    func didSwipeDown(gesture: UISwipeGestureRecognizer) {
        var number = 1
        while number <= 3 {
            for anotherNumber in 0...rowQuantity - 1 {
                guard let labelToBeMoved = cellLabelInPosition((anotherNumber, number)) else {
                    continue
                }
                var count = 0
                while count <= labelToBeMoved.position.y {
                    if decideLabelAction(labelToBeMoved, gesture: gesture, count: count) {
                        break
                    }
                    count += 1
                }
            }
            number += 1
        }
        checkIfSomethingDidMove()
    }
    
    func didSwipeLeft(gesture: UISwipeGestureRecognizer) {
        var number = 1
        while number <= 3 {
            for anotherNumber in 0...rowQuantity - 1 {
                guard let labelToBeMoved = cellLabelInPosition((number, anotherNumber)) else {
                    continue
                }
                var count = 0
                while count <= labelToBeMoved.position.x {
                    if decideLabelAction(labelToBeMoved, gesture: gesture, count: count) {
                        break
                    }
                    count += 1
                }
            }
            number += 1
        }
        checkIfSomethingDidMove()
    }
    
    func didSwipeRight(gesture: UISwipeGestureRecognizer) {
        var number = 2
        while number >= 0 {
            for anotherNumber in 0...rowQuantity - 1 {
                guard let labelToBeMoved = cellLabelInPosition((number, anotherNumber)) else {
                    continue
                }
                var count = 3
                while count >= labelToBeMoved.position.x {
                    if decideLabelAction(labelToBeMoved, gesture: gesture, count: count) {
                        break
                    }
                    count -= 1
                }
            }
            number -= 1
        }
        checkIfSomethingDidMove()
    }
    
    // MARK: helper methods
    
    func setConstraintsForCellView(location : Position) {
        let cellView = cellViewInPosition(location).view
        switch location {
        case (1..<rowQuantity , 1..<rowQuantity):
            let leftCell = cellViewInPosition((location.x - 1, location.y)).view
            let bottomCell = cellViewInPosition((location.x, location.y - 1)).view
            NSLayoutConstraint.activateConstraints([
                cellView.leftAnchor.constraintEqualToAnchor(leftCell.rightAnchor, constant: 5.0),
                cellView.bottomAnchor.constraintEqualToAnchor(bottomCell.topAnchor, constant: -5.0)
                ])
        default:
            if location.x == 0 {
                NSLayoutConstraint.activateConstraints([
                    cellView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 5.0)])
                if location.y != 0 {
                    let bottomCell = cellViewInPosition((location.x, location.y - 1)).view
                    NSLayoutConstraint.activateConstraints([
                        cellView.bottomAnchor.constraintEqualToAnchor(bottomCell.topAnchor, constant: -5.0)])
                }
            }
            if location.y == 0 {
                NSLayoutConstraint.activateConstraints([
                    cellView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -5.0)])
                if location.x != 0 {
                    let leftCell = cellViewInPosition((location.x - 1, location.y)).view
                    NSLayoutConstraint.activateConstraints([
                        cellView.leftAnchor.constraintEqualToAnchor(leftCell.rightAnchor, constant: 5.0)])
                }
            }
        }
    }
    
    func addCellSubviews() {
        for cellView in cellViews {
            view.addSubview(cellView.view)
            cellView.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func compareLabels(firstLabel: UILabel, secondLabel: UILabel) -> Bool {
        if firstLabel.text == secondLabel.text {
            return true
        } else {
            return false
        }
    }
    
    func comparePositions(firstPosition: Position, secondPosition: Position) -> Bool {
        if (firstPosition.x == secondPosition.x) && (firstPosition.y == secondPosition.y) {
            return true
        } else {
            return false
        }
    }
    
    func getIndexOfLabel(inPosition position: Position) -> Int {
        for index in 0..<cellLabels.count {
            if comparePositions(position, secondPosition: cellLabels[index].position) {
                return index
            }
        }
        fatalError()
    }
    
    func cellLabelInPosition(position: Position) -> CellLabel? {
        for cellLabel in cellLabels {
            if comparePositions(position, secondPosition: cellLabel.position) {
                return cellLabel
            }
        }
        return nil
    }
    
    func cellViewInPosition(position: Position) -> CellView {
        for cellView in cellViews {
            if comparePositions(position, secondPosition: cellView.position) {
                return cellView
            }
        }
        fatalError()
    }
    
    func addLabelToRandomFreePosition() {
        let xAxis = GKRandomSource.sharedRandom().nextIntWithUpperBound(rowQuantity)
        let yAxis = GKRandomSource.sharedRandom().nextIntWithUpperBound(rowQuantity)
        
        if cellLabelInPosition((xAxis, yAxis)) == nil {
            addLabel(Number.TwoInThePowerOfOne, position: (xAxis, yAxis))
        } else {
            addLabelToRandomFreePosition()
        }
    }
    
    func addLabel(number: Number, position: Position) {
        let label = UILabel()
        view.addSubview(label)
        setLabel(label, number: number)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
        cellLabels.append((label, position, nil, nil))
        setInitialConstraintsForCellLabel(position)
    }
    
    func setLabel(label: UILabel, number: Number) {
        label.backgroundColor = number.backgroundColor
        label.text = "\(number.rawValue)"
        label.textColor = number.textColor
        label.font = label.font.fontWithSize(number.fontSize)
    }
    
    func checkIfSomethingDidMove() {
        if somethingDidMove {
            addLabelToRandomFreePosition()
            somethingDidMove = false
        }
    }
    
    func checkIfGameIsOver() {
        
    }
    
    func startNewGame() {
        if scoreViewController!.scoreLabel.text == "0" && cellLabels.count == 1 {
            return
        }
        for cellLabel in cellLabels {
            cellLabel.label.removeFromSuperview()
        }
        cellLabels.removeAll()
        cellLabels = []
        scoreViewController?.resetScore()
        
        addLabelToRandomFreePosition()
    }
    
    func decideLabelAction(labelToBeMoved: CellLabel, gesture: UISwipeGestureRecognizer, count: Int) -> Bool {
        let previousLabel = cellLabelInPosition(previousLabelPosition(labelToBeMoved, count: count, gestureDirection: gesture.direction))
        let examinedLabelLocation = examinedLabelPosition(labelToBeMoved, count: count, gestureDirection: gesture.direction)
        let examinedLabel = cellLabelInPosition(examinedLabelLocation)
        let labelToBeMovedLocation = labelToBeMovedPosition(labelToBeMoved, gestureDirection: gesture.direction)
        let wall = wallInDirection(gesture.direction)
        
        if examinedLabel == nil {
            if count == wall {
                moveLabel(labelToBeMoved, toPosition: examinedLabelLocation,
                          direction: gesture.direction, needToSet: false)
                return true
            } else {
                if compareLabels(previousLabel!.label, secondLabel: labelToBeMoved.label) {
                    mergeLabels(previousLabel!, movingLabel: labelToBeMoved, direction: gesture.direction)
                } else {
                    moveLabel(labelToBeMoved, toPosition: examinedLabelLocation, direction: gesture.direction, needToSet: false)
                }
                return true
            }
        } else {
            if count == labelToBeMovedLocation {
                if compareLabels(previousLabel!.label, secondLabel: labelToBeMoved.label) {
                    mergeLabels(previousLabel!, movingLabel: labelToBeMoved, direction: gesture.direction)
                    return true
                }
            }
        }
        return false
    }
    
    func previousLabelPosition(labelToBeMoved: CellLabel, count: Int, gestureDirection: UISwipeGestureRecognizerDirection) -> Position {
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.Down:
            return (labelToBeMoved.position.x, count - 1)
        case UISwipeGestureRecognizerDirection.Up:
            return (labelToBeMoved.position.x, count + 1)
        case UISwipeGestureRecognizerDirection.Right:
            return (count + 1, labelToBeMoved.position.y)
        case UISwipeGestureRecognizerDirection.Left:
            return (count - 1, labelToBeMoved.position.y)
        default:
            fatalError()
        }
    }

    func wallInDirection(gestureDirection: UISwipeGestureRecognizerDirection) -> Int {
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.Up, UISwipeGestureRecognizerDirection.Right :
            return rowQuantity - 1
        case UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Down :
            return 0
        default: fatalError()
        }
    }

    func examinedLabelPosition(labelToBeMoved: CellLabel, count: Int, gestureDirection: UISwipeGestureRecognizerDirection) -> Position {
        switch  gestureDirection {
        case UISwipeGestureRecognizerDirection.Down, UISwipeGestureRecognizerDirection.Up:
            return (labelToBeMoved.position.x, count)
        case UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Right:
            return (count, labelToBeMoved.position.y)
        default:
            fatalError()
        }
    }
    
    func labelToBeMovedPosition(labelToBeMoved: CellLabel, gestureDirection: UISwipeGestureRecognizerDirection) -> Int {
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.Down, UISwipeGestureRecognizerDirection.Up:
        return labelToBeMoved.position.y
        case UISwipeGestureRecognizerDirection.Left, UISwipeGestureRecognizerDirection.Right:
        return labelToBeMoved.position.x
        default:
        fatalError()
        }
    }

}
