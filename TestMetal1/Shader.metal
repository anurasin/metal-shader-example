//
//  Shader.metal
//  TestMetal1
//
//  Created by Anurag on 19/10/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex{
    float4 pos [[position]];
    float4 color;
};


vertex Vertex passThroughVS(device Vertex *vertices[[buffer(0)]],
                            uint vid [[vertex_id]])
{
    return vertices[vid];
}

fragment float4 passThroughFS(Vertex inVertex[[stage_in]])
{
    return inVertex.color;
}
