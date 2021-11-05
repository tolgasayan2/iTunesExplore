//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 30.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
  
  var searchResult: SearchResult!
  var downloadedTask: URLSessionDownloadTask?
  
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
      if searchResult != nil {
        update()
      }
      view.backgroundColor = UIColor.clear
      let newView = GradientView(frame: CGRect.zero)
      newView.frame = view.bounds
      view.insertSubview(newView, at: 0
      )

      popupView.layer.cornerRadius = 10
    }
    
  @IBAction func close(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeUrl) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  deinit {
    downloadedTask?.cancel()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    transitioningDelegate = self
  }
   
  func update() {
    nameLabel.text = searchResult.name
    if searchResult.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = searchResult.artist
    }
    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    //MARK: - Currency
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.string(from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)
    //MARK: - Get Large Image
    if let largeURL = URL(string: searchResult.artworkUrl100 ?? "") {
      downloadedTask = artworkImageView.loadImage(url: largeURL)
   
    }
  }
 
}

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view === self.view
  }
}
extension DetailViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AnimationController()
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideOutAnimationController()
  }
}
