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
    var inputUnit: CGFloat = 15.0
    
    override init() {
        let kernelFunction = """
            kernel vec4 gaussianBlur(sampler img, float sigma){
                mat3 gaussianKernel = mat3(
                    1, 2, 1,
                    2, 4, 2,
                    1, 2, 1
                );
                
                int kernelSize = 3;
                int radius = 1;

                float kernelDivider = 16;
                
                vec2 pixelPosition = destCoord();

                vec4 accumColor = vec4(0, 0, 0, 0);
                
                for (int i = -radius; i <= radius; i++) {
                    for (int j = -radius; j <= radius; j++) {
                        vec4 currentSample = sample(img, samplerTransform(img, pixelPosition + vec2(i,j)));
                        vec4 currentColor = currentSample.rgba;

                        accumColor += currentColor * gaussianKernel[i + 1][j + 1];
                    }
                }

                vec4 resultColor = accumColor / kernelDivider;

                return resultColor;
            }
            """
        kernel = CIKernel(source: kernelFunction)!
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var outputImage : CIImage!
    {
        if let inputImage = inputImage {
            
            let arguments = [inputImage, inputUnit] as [Any]
            let extent = inputImage.extent
            
            return kernel.apply(extent: extent,
                                        roiCallback:
                {
                    (index, rect) in
                    return rect
            }, arguments: arguments)
        }
        return nil
    }
}
