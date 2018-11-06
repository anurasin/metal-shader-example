//
//  AppView.m
//  TestMetal1
//
//  Created by Anurag on 19/10/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

#import "AppView.h"


typedef struct
{
    vector_float4 pos;
    vector_float4 color;
} Vertex;

@implementation AppView

+ (id)layerClass
{
    return [CAMetalLayer class];
}

- (CAMetalLayer *)metalLayer {
    return (CAMetalLayer *)self.layer;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initCode];
    }
    
    return self;
}

- (void)initCode
{
    _device = MTLCreateSystemDefaultDevice();
    self.metalLayer.device = _device;
    self.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    // create a new command Q
    _commandQueue = [_device newCommandQueue];
    _commandBuffer = [_commandQueue commandBuffer];
}

- (void)redraw
{
    // create Vertices
    Vertex vertices [3];
    vertices[0].pos = simd_make_float4(0,0,0,1);
    vertices[0].color = simd_make_float4(1,0,0,1);
    
    vertices[1].pos = simd_make_float4(1,0,0,1);
    vertices[1].color = simd_make_float4(0,1,0,1);
    
    vertices[2].pos = simd_make_float4(0,1,0,1);
    vertices[2].color = simd_make_float4(0,1,0,1);
        
    _vertexBuffer = [_device newBufferWithBytes:vertices
                                         length:sizeof(vertices) options:MTLResourceOptionCPUCacheModeDefault];
    
    
    // lets create a render pass pipeline
    
    id<MTLLibrary> library = [_device newDefaultLibrary];
    id<MTLFunction> vertexFunc = [library newFunctionWithName:@"passThroughVS"];
    id<MTLFunction> fragmentFunc = [library newFunctionWithName:@"passThroughFS"];

    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    pipelineDescriptor.vertexFunction = vertexFunc;
    pipelineDescriptor.fragmentFunction = fragmentFunc;
    
    NSError *error = nil;
    _pipeline = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor
                                                       error:&error];

    
    id<CAMetalDrawable> drawable = [self.metalLayer nextDrawable];
    id<MTLTexture> framebufferTexture = drawable.texture;

    if (drawable)
    {
        MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 0, 1);
        passDescriptor.colorAttachments[0].texture = framebufferTexture;
        passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        
        
        
        
        id<MTLRenderCommandEncoder> commandEncoder = [_commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
        
        [commandEncoder setRenderPipelineState:self.pipeline];
        [commandEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
        
        [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
        [commandEncoder endEncoding];
        
        [_commandBuffer presentDrawable:drawable];
        [_commandBuffer commit];
        NSLog(@"done");
    }
}

- (void)didMoveToWindow
{
    [self redraw];
}



@end


