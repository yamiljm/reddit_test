//
//  HTTPConnectorImpl.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

class HTTPConnectorImpl: HTTPConnector {

    let session: URLSession

    init() {
        self.session = URLSession.shared
    }

    func executeRequest(_ urlRequest: URLRequest, completion: @escaping (Result<Data, HTTPError>) -> Void) {

        session.dataTask(with: urlRequest, completionHandler: { data, response, error in

            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.isOK(),
                let data = data,
                error == nil
                else {
                    let code = (response as? HTTPURLResponse)?.statusCode
                    completion(Result.failure(HTTPError(statusCode: code, message: error?.localizedDescription)))
                    return
            }

            completion(Result.success(data))
        }).resume()
    }
}

private extension HTTPURLResponse {

    func isOK() -> Bool {
        return self.statusCode >= 200 && self.statusCode < 400
    }

}


