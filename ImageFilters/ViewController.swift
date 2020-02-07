//
//  ViewController.swift
//  ImageFilters
//
//  Created by Vlad Eliseev on 05/09/2019.
//  Copyright © 2019 Vlad Eliseev. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    var filter = GaussianFilter()

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        guard let currentImage = imageView.image else {
            print("No image!")
            return
        }
        
        filter.inputImage = CIImage(image: currentImage)
        
        if let outputImage = filter.outputImage {
            print("Output image getted!")
            imageView.image = UIImage(ciImage: outputImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let imgUrl = Bundle.main.url(forResource: "woman", withExtension: "png") else {return}
        
        if let image = UIImage(contentsOfFile: imgUrl.path) {
            imageView.image = image
        }
    }

}
