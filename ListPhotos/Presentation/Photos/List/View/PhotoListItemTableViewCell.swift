//
//  PhotoListItemTableViewCell.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import UIKit

class PhotoListItemTableViewCell: UITableViewCell {
  
    static let identifier = "PhotoListItemTableViewCell"
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: PhotoListItemTableViewCell.identifier, bundle: nil)
        return nib
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        self.cardView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellWithPhoto(_ photoViewModel: PhotoListItemViewModel) {
        authorNameLabel.text = photoViewModel.authorName
        
        let urlString = "https://picsum.photos/id/\(photoViewModel.id)/460/426"
        print(urlString)
        
        if let url = URL(string: urlString) {
            photoImageView.loadImage(from: url, identifier: photoViewModel.id)
        } 
    }
}
