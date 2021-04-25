//
//  CollectionViewCell.swift
//  TMDb-ios
//
//  Created by Juan Felipe Torres on 24/04/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieView.layer.cornerRadius = 12
        movieView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        movieImage.layer.cornerRadius = 12
        movieImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @IBAction func movieDetailPressed(_ sender: Any) {
        
    }
}
