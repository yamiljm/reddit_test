//
//  HTTPConnector.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

struct HTTPError: Error  {
    let statusCode: Int?
    let message: String?
}

protocol HTTPConnector {

    func executeRequest(_ urlRequest: URLRequest, completion: @escaping (Result<Data, HTTPError>) -> Void)

}
