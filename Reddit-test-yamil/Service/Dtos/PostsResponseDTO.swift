//
//  PostsResponseDTO.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

struct PostsResponseDTO: Decodable {

    struct Data: Decodable {
        let children: [PostDTO]?
        let after: String?
        let before: String?
    }

    let kind: String
    let data: PostsResponseDTO.Data?
}
