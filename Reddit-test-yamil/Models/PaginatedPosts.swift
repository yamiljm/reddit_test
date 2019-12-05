//
//  PaginatedPosts.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

struct PaginatedPosts {

    let after: String?
    let before: String?
    let childrens: [Post]?

    init(after: String? = nil, before: String? = nil, childrens: [Post]? = []) {
        self.after = after
        self.childrens = childrens
        self.before = before
    }
}
