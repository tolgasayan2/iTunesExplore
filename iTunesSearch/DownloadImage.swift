//
//  DownloadImage.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 29.10.2021.
//



import UIKit

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    let dowloadedTask = session.downloadTask(with: url) {[weak self] url, _, error in
      if error == nil, let url = url,
         let data = try? Data(contentsOf: url),
         let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
        }
      }
    }
    dowloadedTask.resume()
    return dowloadedTask
  }
}
