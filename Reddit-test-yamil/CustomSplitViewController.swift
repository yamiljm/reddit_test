//
//  CustomSplitViewController.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class CustomSplitViewController: UISplitViewController, UISplitViewControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .automatic
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController: UIViewController) -> Bool {

        guard let secondaryAsNavController = secondaryViewController as? PostDetailViewController else {
            return false

        }

        if secondaryAsNavController.post == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}
