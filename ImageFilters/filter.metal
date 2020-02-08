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


array<array<float, 11>, 11> gaussianKernel(float sigma, int size){
    array<array<float, 11>, 11> gaussianKernel;
    
    for(int i = 0; i < size; ++i){
        for(int j = 0; j < size; ++j){
            gaussianKernel[i][j] = 0;
        }
    }
    
    for(int i = 0; i < size; ++i){
        for(int j = 0; j < size; ++j){
            gaussianKernel[i][j] = gaussian(i - size / 2, j - size / 2, sigma);
        }
    }
    
    return gaussianKernel;
}



extern "C" { namespace coreimage {
    
    struct KernelServiceInfo {
        float sigma;
        int size;
    };
    
    float4 gaussianBlur(sampler img, float fsize, float sigma, destination computedPixel){
        
        int size = fsize;
        
        array<array<float, 11>, 11> theKernel = gaussianKernel(sigma, size);
        
        int radius = size / 2;
        
        // Calculate the divider
        float kernelDivider = 0;
        
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
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
