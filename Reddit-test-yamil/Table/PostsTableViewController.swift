//
//  PostsTableViewController.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class PostsTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let delegate = PostsTableViewDelegate()
    let dataSource = PostsDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

}
