//
//  PostCell.swift
//  Reddit-test-yamil
//
//  Created by Yamil Jalil on 05/12/2019.
//  Copyright © 2019 Yamil Jalil. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var thumbnail: UIImageView!

    var post: Post?
    var cellRow: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViewFromPost(_ post: Post, forRow row: Int, with imageProvider: ImageProvider) {

        title.text = post.title
        thumbnail?.image = UIImage(named: "placeholder")
        cellRow = row

        if let imageURL = post.thumbnailURL {
            imageProvider.loadImage(from: imageURL, forRow: row) { [weak self] (loadedImage: UIImage?, row: Int) in

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


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
