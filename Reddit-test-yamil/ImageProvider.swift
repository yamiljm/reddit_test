//
//  ImageProvider.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import Foundation
import UIKit

class ImageProvider {

    var task: URLSessionDownloadTask
    var session: URLSession
    var cache: NSCache<AnyObject, AnyObject>

    init() {
        self.task = URLSessionDownloadTask()
        self.session = URLSession.shared
        self.cache = NSCache()
    }

    func loadImage(from url: URL, forRow row: Int? = nil, completion: @escaping (UIImage?, Int?) -> Void ) {
        let urlHash = url.absoluteString.hashValue
        if (self.cache.object(forKey: urlHash as AnyObject) != nil){
            let cachedImage = self.cache.object(forKey: urlHash as AnyObject) as? UIImage
            completion(cachedImage, row)
            return
        }else{
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    self.cache.setObject(img, forKey: urlHash as AnyObject)
                    completion(img, row)
                }
            })
            task.resume()
        }

    }

}
