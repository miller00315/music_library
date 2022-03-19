//
//  AlbumTableViewCell.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumPictureImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    static let identifier = "AlbumTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(albumName: String, trackName: String, imageUrl: String) {
        
        albumPictureImageView.loadImage(from: imageUrl)
        albumNameLabel.text = albumName
        trackNameLabel.text = trackName
    }
    
}
