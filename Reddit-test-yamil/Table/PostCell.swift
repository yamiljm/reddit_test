//
//  PostCell.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sinceDate: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var viewedBullet: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!

    var cellRow: Int?
    var viewed = false

    override func awakeFromNib() {
        super.awakeFromNib()
        viewedBullet.layer.cornerRadius = viewedBullet.frame.size.width/2
        viewedBullet.clipsToBounds = true
    }

    func updateViewFromPost(_ post: Post, forRow row: Int, with imageProvider: ImageProvider) {

        title.text = post.title
        thumbnail?.image = UIImage(named: "placeholder")
        author.text = post.author
        sinceDate.text = post.createdSince

        if let numberOfComments = post.numberOfComments, numberOfComments > 0 {
            comments.text = "\(numberOfComments) comments"
        } else {
            comments.text = "No comments"
        }

        viewed = post.viewed
        cellRow = row

        if let imageURL = post.thumbnailURL {
            loadImageFromURL(imageURL, forRow: row, with: imageProvider)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewedBullet.backgroundColor = selected || viewed ? .clear : .blue
    }

    private func loadImageFromURL(_ url: URL, forRow row: Int, with imageProvider: ImageProvider) {
        imageProvider.loadImage(from: url, forRow: row) { [weak self] (loadedImage: UIImage?, row: Int) in

            guard let self = self else {
                return
            }
            //Check if the cell is visible
            if self.cellRow == row {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.thumbnail.image = loadedImage
                })
            }
        }
    }
    
}
