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

    var items: [String]

    override init() {

        items = [String]()
        super.init()

        //TODO: remove. For test cell creation
        (1...10).forEach {[weak self] (i) in
            guard let self = self else {
                return
            }
            self.items.append("Hello \(i)")
        }
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

        cell.title.text = items[indexPath.row]
        return cell
    }

}
