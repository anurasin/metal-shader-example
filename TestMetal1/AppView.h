//
//  AppView.h
//  TestMetal1
//
//  Created by Anurag on 19/10/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

#ifndef AppView_h
#define AppView_h


@import UIKit;
@import Metal;
@import simd;

@interface AppView : UIView

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (readonly) CAMetalLayer *metalLayer;

@property id<MTLDevice> device;

@property id<MTLCommandQueue> commandQueue;

@property id<MTLCommandBuffer> commandBuffer;


@property id<MTLRenderPipelineState> pipeline;

@property id<MTLBuffer> vertexBuffer;

@end


#endif /* AppView_h */
