//
//  RedditService.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

protocol RedditService {

    var httpConnector: HTTPConnector { get }

    func getPostsForTopic(_ topic: String, withParams searchParams: SearchParams?, completion: @escaping (Result<PaginatedPosts?, Error>) -> Void)

}

enum ServiceError: Error {
   case invalidURL
   case decodeError
}

struct SearchParams {
    let after: String?
    let before: String?
    let count: Int?
    let limit: Int?
}
