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

    let dataSource = PostsDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTable()
    }

    private func initializeTable() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "postDetail" {
            guard let postDetailViewController = segue.destination as? PostDetailViewController else {
                return
            }

            if let selectedRow = tableView.indexPathForSelectedRow?.row  {
                print("Selected row \(selectedRow)")
                postDetailViewController.detail = dataSource.items[selectedRow]
            }
        }
    }

}

extension PostsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "postDetail", sender: indexPath.row)
    }
}
