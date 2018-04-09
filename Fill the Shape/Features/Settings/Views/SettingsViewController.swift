//
//  SettingsViewController.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

class SettingsViewController: UIViewController, StoreSubscriber {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: ReSwift setup
    override func viewWillAppear(_ animated: Bool) {
        mainStore.subscribe(self)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        mainStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        print ("Grabbing new state")
    }
    
}
