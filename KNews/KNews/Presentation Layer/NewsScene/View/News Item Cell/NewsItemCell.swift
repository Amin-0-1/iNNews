//
//  NewsItemCell.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import UIKit
import SDWebImage

class NewsItemCell: UITableViewCell {

    @IBOutlet var uiImage: UIImageView!
    @IBOutlet var uiAuthor: UILabel!
    @IBOutlet var uiTitle: UILabel!
    @IBOutlet var uiDescription: UILabel!
    @IBOutlet var uiSource: UILabel!
    
    func bindNewsItem(item:NewsItem) {
        selectionStyle = .none

        uiTitle.text = item.title ?? "Title"
        uiAuthor.text = item.author ?? "Auther"
        uiDescription.text = item.description ?? "This is description of the news item"
        uiSource.text = item.url
        
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        uiImage.sd_setImage(with: URL(string: item.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
