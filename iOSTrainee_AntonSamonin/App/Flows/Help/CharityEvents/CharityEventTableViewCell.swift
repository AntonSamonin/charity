//
//  CharityEventTableViewCell.swift
//  iOSTrainee_AntonSamonin
//
//  Created by Антон Самонин on 19/07/2019.
//  Copyright © 2019 Anton Samonin. All rights reserved.
//

import UIKit

class CharityEventTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var charityEventImageView: UIImageView!
    @IBOutlet private weak var charityEventNameLabel: UILabel!
    @IBOutlet private weak var charityEventPreviewLabel: UILabel!
    @IBOutlet private weak var charityEventDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        charityEventImageView.image = nil
        charityEventNameLabel.text = nil
        charityEventDateLabel.text = nil
        charityEventPreviewLabel.text = nil
    }
    
    func configuration(event: Event, viewModel: EventsViewModel) {
        charityEventNameLabel.text = event.title
        charityEventPreviewLabel.text = event.eventDescription
        charityEventDateLabel.text = viewModel.eventDateFormatter(eventDate: event.date)
        if let photo = event.photos?[0] {
        charityEventImageView.image = UIImage(imageLiteralResourceName: photo)
        }
    }
}

