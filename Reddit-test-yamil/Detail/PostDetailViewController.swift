//
//  PostDetailViewController.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    var detail: String?

    @IBOutlet weak var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.text = detail

    }
}
