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
    @IBOutlet weak var sigmaSlider: UISlider!
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        guard let currentImage = imageView.image else {
            print("No image!")
            return
        }
        
        filter.inputImage = CIImage(image: currentImage)
        filter.sigma = sigmaSlider.value
        
        if let outputImage = filter.outputImage {
            print("Output image getted!")
            imageView.image = UIImage(ciImage: outputImage)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        imageView.image = image
    }
}
