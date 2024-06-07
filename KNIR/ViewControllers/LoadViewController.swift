//
//  LoadViewController.swift
//  KNIR
//
//  Created by elena on 23.05.2024.
//

import UIKit
class LoadViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Launch View did load")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Launch View will apear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Launch View did apear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        print("Launch View will disappear")

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        print("Launch View did disappear")
    }
}
