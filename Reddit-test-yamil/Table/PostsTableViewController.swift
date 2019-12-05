//
//  PostsTableViewController.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class PostsTableViewController: UIViewController {

    private enum State {
        case empty
        case loading
        case loaded
        case error
    }

    private struct Const {
        static let defaultTopic = "anime"
        static let defaultLimit = 50
    }

    @IBOutlet weak var tableView: UITableView!

    private let dataSource: PostsDataSource
    private var state: State
    private let service: RedditService
    private var newestPostId: String?

    required init?(coder: NSCoder) {
        self.dataSource = PostsDataSource()
        self.state = .empty
        self.service = RedditServiceImpl()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTable()

        refreshTableView()
    }

    private func initializeTable() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "postCell")
    }


    func refreshTableView(after: String? = nil, count: Int = 0){

        state = .loading

        let params = SearchParams(after: after, count: count, limit: Const.defaultLimit)

        service.getPostsForTopic(Const.defaultTopic, withParams: params) { [weak self] (result: Result<PaginatedPosts?, Error>) in

            guard let self = self else {
                return
            }

            switch result {
            case .success(let paginatedEntries):
                print("Retrived \(paginatedEntries?.childrens?.count ?? 0)")

                if let childrens = paginatedEntries?.childrens {
                    self.dataSource.append(childrens)
                    print("Items count \(self.dataSource.count)")
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                }

                print("Paginated after \(paginatedEntries?.after ?? "none")")
                self.newestPostId = paginatedEntries?.after
                self.state = .loaded

            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async(execute: { () -> Void in
                    let alert = UIAlertController(title: "Ups!", message: "Error retrieving posts", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                })
                self.state = .error
            }

            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.tableFooterView?.isHidden = true
            })

        }

    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "postDetail" {
            guard let postDetailViewController = segue.destination as? PostDetailViewController else {
                return
            }

            if let selectedRow = tableView.indexPathForSelectedRow?.row  {
                print("Selected row \(selectedRow)")
                postDetailViewController.detail = dataSource.itemAt(selectedRow).title
            }
        }
    }

}

extension PostsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "postDetail", sender: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }

}
