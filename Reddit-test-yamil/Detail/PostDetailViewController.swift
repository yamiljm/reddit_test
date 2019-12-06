//
//  PostDetailViewController.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    var post: Post?
    weak var imageProvider: ImageProvider?

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        author.text = post?.author
        detailTextView.text = post?.title

        if let url = post?.thumbnailURL {
            imageProvider?.loadImage(from: url) { [weak self] (loadedImage: UIImage?, row: Int?) in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.postImage.image = loadedImage
                })
            }
        } else {
            postImage.image = UIImage(named: "placeholder")
        }


        view.layoutIfNeeded()
    }


    private func loadImageFromURL(_ url: URL, forRow row: Int, with imageProvider: ImageProvider?) {

        guard let strongImageProvider = imageProvider else {
            print("Error: not image provider found")
            return
        }

        strongImageProvider.loadImage(from: url, forRow: row) { [weak self] (loadedImage: UIImage?, row: Int?) in

            guard let self = self else {
                return
            }

            DispatchQueue.main.async(execute: { () -> Void in
                self.postImage.image = loadedImage
            })

        }
    }
}
