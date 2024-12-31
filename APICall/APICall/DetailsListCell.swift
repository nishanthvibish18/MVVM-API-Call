//
//  DetailsListCell.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import UIKit

class DetailsListCell: UITableViewCell {

    @IBOutlet weak var dateLabelText: UILabel!
    @IBOutlet weak var descriptionLabelText: UILabel!
    @IBOutlet weak var titleLabelText: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.productImageView.contentMode = .scaleToFill
        self.productImageView.layer.cornerRadius = 8
        self.productImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

         func loadImage(from data: Data) {
            DispatchQueue.global().async {
              if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                }
            }
        }
    
}
