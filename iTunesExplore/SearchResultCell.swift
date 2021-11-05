//
//  SearchResultCell.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 20.10.2021.
//

import UIKit

class SearchResultCell: UITableViewCell {
  
  var downloadedTask: URLSessionDownloadTask?
  
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configure(for result: SearchResult){
    nameLabel.text = result.name
    if result.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
    }
    artworkImageView.image = UIImage(systemName: "bookmark.circle")
    if let smallUrl = URL(string: result.artworkUrl60 ?? "") {
      downloadedTask = artworkImageView.loadImage(url: smallUrl)
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadedTask?.cancel()
    downloadedTask = nil
  }
  
}
