//
//  MovieCell.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 9/17/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewlabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    var movie: Movie! {
     
        didSet {
            titleLabel.text = movie.title
            overviewlabel.text = movie.overview
            
            let baseUrlString = "https://image.tmdb.org/t/p/w500"
            print("----->>>>",movie.posterUrl)
//            let posterPath = movie.posterUrl as? String
            
            let posterpathURL = URL(string: baseUrlString + movie.posterUrl!)!
            posterImageView.af_setImage(withURL: posterpathURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
