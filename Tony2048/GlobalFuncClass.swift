//
//  GlobalFuncClass.swift
//  Tony2048
//
//  Created by Anthony Latsis on 25.04.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import Foundation
import UIKit

protocol GlobalMethodsClassType {
    static func addObjectsToView(objects: [AnyObject], toView view: UIView)
}

final class GlobalMethodsClass: GlobalMethodsClassType {
    class func addObjectsToView(objects: [AnyObject], toView view: UIView) {
        for subview in objects {
            if let object = subview as? UIView {
                object.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(object)
            }
            if let object = subview as? UIGestureRecognizer {
                view.addGestureRecognizer(object)
            }
        }
    }
}