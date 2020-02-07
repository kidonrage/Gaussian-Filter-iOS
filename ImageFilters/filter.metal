//
//  filter.metal
//  ImageFilters
//
//  Created by Vlad Eliseev on 07.02.2020.
//  Copyright © 2020 Vlad Eliseev. All rights reserved.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h>
using namespace metal;

float gaussian(int x, int y, float sigma){
    int top = -(x * x + y * y);
    float bottom = sigma * sigma * 2;
    
    return exp(top / bottom) / sqrt(bottom * 3.14159265);
}


array<array<float, 3>, 3> gaussianKernel(float sigma){
    array<array<float, 3>, 3> gaussianKernel;
    
    for(int i = 0; i < 3; ++i){
        for(int j = 0; j < 3; ++j){
            gaussianKernel[i][j] = gaussian(i - 3 / 2, j - 3 / 2, sigma);
        }
    }

    return gaussianKernel;
}

extern "C" { namespace coreimage {
    
    float4 gaussianBlur(sampler img, float sigma, destination computedPixel){
        array<array<float, 3>, 3> theKernel = gaussianKernel(1.0);
        
        int radius = 1;
        
        // Calculate the divider
        float kernelDivider = 0;
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                kernelDivider += theKernel[i][j];
            }
        }
        
        float2 pixelPosition = computedPixel.coord();

        float4 accumColor = float4(0, 0, 0, 0);
        
        for (int i = -radius; i <= radius; i++) {
            for (int j = -radius; j <= radius; j++) {
                float4 currentSample = sample(img, samplerTransform(img, pixelPosition + float2(i,j)));
                float4 currentColor = currentSample.rgba;

                accumColor += currentColor * theKernel[i + 1][j + 1];
            }
        }

        float4 resultColor = accumColor / kernelDivider;

        return resultColor;
    }
    
}}
