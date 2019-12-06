//
//  PostTransformer.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation

protocol PostTransformerType {

    func transformPostDTO(_ dto: PostsResponseDTO) -> PaginatedPosts

}

struct PostTransformer: PostTransformerType {

    func transformPostDTO(_ dto: PostsResponseDTO) -> PaginatedPosts {


        let childrens = dto.data?.children?.map( { child -> Post in
            let data = child.data
            return Post(title: data.title,
                        thumbnailURL: createURL(data.thumbnail),
                        name: data.name,
                        created: data.created,
                        numberOfComments: data.numComments,
                        author: data.author)
        })

        return PaginatedPosts(after: dto.data?.after, before: dto.data?.before, childrens: childrens)
    }

    private func createURL(_ urlString: String?) -> URL? {

        guard let safeUrlString = urlString, let url = URL(string: safeUrlString), url.isValid() else {
            return nil
        }
        return url
    }

}

private extension URL {
    func isValid() -> Bool {
        return !(scheme?.isEmpty ?? false && host?.isEmpty ?? false)
    }
}
