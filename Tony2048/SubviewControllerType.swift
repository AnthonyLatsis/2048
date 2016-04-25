//
//  SubviewTypeProtocol.swift
//  Tony2048
//
//  Created by Anthony Latsis on 20.04.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import Foundation

protocol SubviewControllerType {
    
    func setConstraintsForView(inSuperview superViewController: AnyObject)
    func settingsForView()
}
