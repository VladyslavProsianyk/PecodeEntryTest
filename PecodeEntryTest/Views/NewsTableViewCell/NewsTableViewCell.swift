//
//  NewsTableViewCell.swift
//  PecodeEntryTest
//
//  Created by Vladyslav Prosianyk on 16.06.2022.
//

import UIKit
import SDWebImage

class NewsTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
    }
    
    var model: NewsModel?

    func configure(with model: NewsModel) {
        self.model = model
        
        newsImageView.sd_setImage(with: URL(string: model.urlToImage ?? ""))
        titleLabel.text = model.title
        authorLabel.text = model.author
        descriptionLabel.text = model.description
        sourceLabel.text = model.source.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
