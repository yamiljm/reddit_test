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
        tableView.separatorColor = UIColor.lightGray
        tableView.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(PostsTableViewController.refreshTableView), for: .valueChanged)
    }


    @objc
    func refreshTableView() {
        dataSource.removeAll()
        tableView.reloadData()
        refreshTableView(after: nil, count: 0)
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

         self.tableView.refreshControl?.endRefreshing()

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

        let posibleCell = tableView.cellForRow(at: indexPath) as? PostCell

        guard let cell = posibleCell else {
            print("Error dequeing cell")
            return
        }

        cell.viewed = true
        dataSource.setItemViewed(indexPath.row)

        performSegue(withIdentifier: "postDetail", sender: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(136)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard state != .loading else {
            return
        }

        let lastElement = dataSource.count - 1

        if indexPath.row == lastElement {
            refreshTableView(after: newestPostId, count: 0)
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            self.tableView.tableFooterView?.backgroundColor = UIColor.black
        }
    }


}
