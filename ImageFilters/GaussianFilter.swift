//
//  GaussianFilter.swift
//  ImageFilters
//
//  Created by Vlad Eliseev on 05.02.2020.
//  Copyright © 2020 Vlad Eliseev. All rights reserved.
//

import CoreImage

class GaussianFilter: CIFilter {
    
    private let kernel: CIKernel
    var inputImage: CIImage?
    var kernelSize: Int = 3
    var sigma: Float = 15.0
    
    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        kernel = try! CIKernel(functionName: "gaussianBlur", fromMetalLibraryData: data)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var outputImage : CIImage!
    {
        if let inputImage = inputImage {
            
            let arguments = [inputImage, kernelSize, sigma] as [Any]
        
            let extent = inputImage.extent
            
            return kernel.apply(
                extent: extent,
                roiCallback: { (index, rect) in
                    return rect
                },
                arguments: arguments)
        }
        return nil
    }
}
