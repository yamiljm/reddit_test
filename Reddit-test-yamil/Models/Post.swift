//
//  Post.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

struct Post {

    let title: String?
    let thumbnailURL: String?
    let name: String?
    var viewed = false

    mutating func setViewed() {
        viewed = true
    }
    
}
