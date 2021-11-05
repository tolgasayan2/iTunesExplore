//
//  OpenViewController.swift
//  iTunesExplore
//
//  Created by Tolga Sayan on 5.11.2021.
//

import UIKit

class OpenViewController: UIViewController {
  @IBOutlet weak var image: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      DispatchQueue.main.async {
        self.image.image = UIImage(named: "Image")
      }
    }
    
  @IBAction func goButton(_ sender: Any) {
    performSegue(withIdentifier: "toMain", sender: nil)
  }
  
}
