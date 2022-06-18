//
//  NewsTableViewCell.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import UIKit
import SDWebImage

class NewsTableViewCell: BaseTableViewCell {
    
    var viewModel: NewsTableViewCellViewModelProtocol?
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var likedButton: UIButton!
    
    var newsIsLiked: Bool = false {
        didSet {
            likedButton.setImage(UIImage(systemName: newsIsLiked ? "heart.fill" : "heart"), for: .normal)
        }
    }
    
    var newsModel: NewsModelProtocol?
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let newsModel = newsModel else { return }
        newsIsLiked = !newsIsLiked
        
        if !newsIsLiked {
            viewModel?.deleteExactNewsFromLiked(newsUrl: newsModel.url ?? "")
        } else {
            if let realmModel = newsModel as? NewsResponseModel {
                viewModel?.saveNewsToLiked(realmModel)
            }
        }
    }
    
    func configure(with model: NewsResponseModel) {
        newsModel = model
        newsImageView.sd_setImage(with: URL(string: model.urlToImage ?? ""))
        titleLabel.text = model.title
        authorLabel.text = model.author
        descriptionLabel.text = model.description
        sourceLabel.text = model.source.name
    }
    
    func configure(with model: NewsRealmModel) {
        newsModel = model
        newsImageView.sd_setImage(with: URL(string: model.urlToImage ?? ""))
        titleLabel.text = model.title
        authorLabel.text = model.author
        descriptionLabel.text = model.desc
        sourceLabel.text = model.source?.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
