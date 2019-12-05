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
    let thumbnailURL: URL?
    let name: String?
    let created: TimeInterval?
    let numberOfComments: Int?
    let author: String?
    var viewed = false

    var createdSince: String? {
        guard let interval = created else {
            return nil
        }
        return Date(timeIntervalSince1970: interval).timeAgoSinceDate()
    }

    mutating func setViewed() {
        viewed = true
    }
    
}
