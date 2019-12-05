//
//  PostDTO.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

struct PostDTO: Decodable  {

    struct Data: Decodable {
        let id: String
        let title: String?
        let thumbnailURL: String?
        let name: String?
    }

    let data: PostDTO.Data
    
}
