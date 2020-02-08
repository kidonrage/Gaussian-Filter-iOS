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
    let sizeItems = [3, 5, 11]
    var selectedImage: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sigmaSlider: UISlider!
    @IBOutlet weak var kernelSizeSegmentedControl: UISegmentedControl!
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        filter.kernelSize = sizeItems[kernelSizeSegmentedControl.selectedSegmentIndex]
        filter.inputImage = CIImage(image: selectedImage)
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
        
        for (index, size) in sizeItems.enumerated() {
            kernelSizeSegmentedControl.setTitle("\(size)x\(size)", forSegmentAt: index)
        }
        
        guard let imgUrl = Bundle.main.url(forResource: "woman", withExtension: "png") else {return}
        
        if let image = UIImage(contentsOfFile: imgUrl.path) {
            selectedImage = image
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
