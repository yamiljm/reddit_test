//
//  RedditServiceImpl.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

class RedditServiceImpl: RedditService {

    private struct Const {
        static let partialTopPath = "top.json"
        static let afterParam = "after"
        static let beforeParam = "before"
        static let limitParam = "limit"
        static let countParam = "count"
    }

    let httpConnector: HTTPConnector
    let transformer: PostTransformerType

    init(httpConnector: HTTPConnector = HTTPConnectorImpl(), transformer: PostTransformerType = PostTransformer()) {
        self.httpConnector = httpConnector
        self.transformer = transformer
    }

    func getPostsForTopic(_ topic: String, withParams searchParams: SearchParams? = nil, completion: @escaping (Result<PaginatedPosts?, Error>) -> Void) {

        guard let request = createRequestForTopic(topic, withParams: searchParams) else {
            completion(Result.failure(ServiceError.invalidURL))
            return
        }

        httpConnector.executeRequest(request) {[weak self] (result: Result<Data, HTTPError>) in

            print("Request \(request.url?.absoluteString ?? "nil request")")

            guard let self = self else {
                return
            }

            switch result {
            case .success(let data):
                guard let decodedResponse: PostsResponseDTO = try? JSONDecoder().decode(PostsResponseDTO.self, from: data) else {
                    completion(Result.failure(ServiceError.decodeError))
                    return
                }
                completion(Result.success(self.transformer.transformPostDTO(decodedResponse)))

            case .failure(let error):
                print(error.localizedDescription)
                completion(Result.failure(error))
            }
        }
    }


    //TODO: make a builder to create the request
    private func createRequestForTopic(_ topic: String, withParams params: SearchParams?) -> URLRequest? {

        var urlComponents = baseURLComponents(forTopic: topic)

        if let queryParams = params {
            urlComponents.queryItems = createQueryParamsUsing(from: queryParams)
        }

        guard let validURL = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: validURL)
        request.httpMethod = "get"
        return request
    }

    private func baseURLComponents(forTopic topic: String) -> URLComponents {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "reddit.com"
        component.path = "/r/\(topic)/\(Const.partialTopPath)"
        return component
    }

    private func createQueryParamsUsing(from params: SearchParams) -> [URLQueryItem] {

        var queryItems = [URLQueryItem]()

        if let afterParam = params.after {
            queryItems.append(contentsOf: [URLQueryItem(name: Const.afterParam, value: afterParam)])
        }

//        if let beforeParam = params.before {
//            queryItems.append(URLQueryItem(name: Const.beforeParam, value: beforeParam))
//        }

        if let limitParam = params.limit {
            queryItems.append(URLQueryItem(name: Const.limitParam, value: limitParam.description))
        }

        if let countParam = params.count, countParam > 0 {
            queryItems.append(URLQueryItem(name: Const.countParam, value: countParam.description))
        }

        return queryItems
    }

//    private func transformResponse(dto: PostsResponseDTO) -> PaginatedPosts {
//        let childrens = dto.data?.children?.map {
//            return Post(title: $0.data.title, thumbnailURL: $0.data.thumbnailURL, name: $0.data.name)
//        }
//
//        return PaginatedPosts(after: dto.data?.after, before: dto.data?.before, childrens: childrens)
//    }
}
