//
//  PostsDataSource.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation
import UIKit

class PostsDataSource: NSObject {

    private var items: [Post]

    var count: Int {
        return items.count
    }

    override init() {
        items = [Post]()
        super.init()
    }

    func append(_ newPosts: [Post]?) {
        guard let posts = newPosts else {
            return
        }
        items.append(contentsOf: posts)
    }

    func itemAt(_ position: Int) -> Post {
        return items[position]
    }

}

extension PostsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let posibleCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell

        guard let cell = posibleCell else {
            print("Error dequeing cell")
            return UITableViewCell()
        }

        cell.title.text = items[indexPath.row].title
        return cell
    }

}
