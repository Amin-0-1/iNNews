//
//  DetailsVC.swift
//  iNNNews
//
//  Created by Amin on 17/07/2021.
//

import UIKit
import SDWebImage
import XLMediaZoom

class DetailsVC: UIViewController {

    var itemNews: NewsItem!
    var viewModel: DetailsSending!
    
    @IBOutlet var uiImage: UIImageView!
    @IBOutlet var uiImageView: UIView!
    @IBOutlet var uiTitle: UILabel!
    @IBOutlet var uiAuthor: UILabel!
    @IBOutlet var uiPublishDate: UILabel!
    @IBOutlet var uiDescription: UILabel!
    @IBOutlet var uiSourceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailsVM()
        
        setupImage()
        setupDescription()
        setupSourceButton()
        
        uiTitle.text = itemNews.title ?? "Title"
        uiAuthor.text = itemNews.author ?? "Author"
        uiPublishDate.text = itemNews.publishedAt ?? "Today"
        
        title = itemNews.author
    }
    func setupImage() {
        
        uiImageView.layer.borderWidth = 0.3
        uiImageView.layer.cornerRadius = 25
        uiImage.layer.cornerRadius = 25
        uiImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        uiImageView.layer.shadowRadius = 1
        uiImageView.layer.shadowOpacity = 0.8
        uiImageView.layer.masksToBounds = false
        
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        uiImage.sd_setImage(with: URL(string: itemNews.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
        
    }

    func setupDescription() {
        guard let description = itemNews.description else { return }
        guard let content = itemNews.content else { return }


        let fullString = NSMutableAttributedString()

        let desc = NSAttributedString(string: "\(description)\n\n", attributes: [NSAttributedString.Key.foregroundColor :UIColor.darkGray ])

        let cont = NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        fullString.append(desc)
        fullString.append(cont)
        
        uiDescription.attributedText = fullString
    }
    
    func setupSourceButton() {
        guard let _ = itemNews.url else { uiSourceButton.isHidden = true ; return }
        
        uiSourceButton.layer.cornerRadius = uiSourceButton.layer.frame.height / 2
        uiSourceButton.layer.shadowOpacity = 0.8
        uiSourceButton.layer.shadowRadius = 1
        uiSourceButton.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    @IBAction func uiSourcebtn(_ sender: UIButton) {
        guard let url = itemNews.url else { return }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut]) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { (_) in
            sender.transform = .identity
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self = self else { return }

                let newsSourceWebPage = NewsSourceVC()
                newsSourceWebPage.url = url
                self.navigationController?.pushViewController(newsSourceWebPage, animated: true)
            }
        }
    }
    
}
