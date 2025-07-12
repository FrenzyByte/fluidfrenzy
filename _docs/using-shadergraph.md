---
title: Using ShaderGraph
permalink: /docs/using_shadergraph/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

Create your own shaders using ShaderGraph and the Fluid Frenzy ShaderGraph nodes. You can create custom shaders for the **Fluid Simulation**, **Terraform Terrain**, and **Procedural particles**. To get started it is recommended to look at the example shader found at `FluidFrenzy\Runtime\Rendering\Shaders\ShaderGraph\SampleFluidSimple`. This example demonstrates how to sample the fluid simulation's data like the height, depth. velocity, layer, normals and how to apply flowmapping.

#### Fluid Simulation Nodes

| Node                                | Description                                  |
|-------------------------------------|--------------------------------------------------|
| ApplyClipSpaceOffset                | Applies a depth offset to the clipspace position |
| ClampVector2                        | Clamps a Vector2 to a given length |
| ClipFluid                           | Calls hlsl clip to discard any invisible fluid layer's pixels. |
| EvaluateWaterFoamMask               | Evaluate the visibly of the foam based on factors like the selected mode, albedo, and foam mask. |
| FluidClipHeight                     | Shader subgraph for fluid clip height       |
| FluidUV0To1                         | Returns the 0 to 1 UV based of the FluidUV from the SampleSimulationData node. |
| FluidUVGrid                         | Returns the Grid UV based of the FluidUV from the SampleSimulationData node. This UV matches the Unity Terrain height sampling UV. |
| LayerToMask                         | Converts the layer data from the SampleSimulationData to a -1 to 1 mask. |
| SampleFoam                          | Samples the fluid simulation's foam mask.|
| SampleHeightVelocity                | Samples the fluid simulation's height and velocity data. |
| SampleNormal                        | Samples the fluid simulation's surface normal.       |
| SampleSimulationData                | Samples all the fluid simulation data at a provided UV coordinate. |
| SampleSimulationDataFromPositionOS  | Samples all the fluid simulation data at a provided object space position. |
| SampleSimulationDataFromPositionWS  | Samples all the fluid simulation data at a provided world space position. |
| SampleTerrain                       | Samples the terrain height used in the fluid simulation. |
| SampleTex2DFlow                     | Samples the provided texture using the selected flow mapping technique. |
| SampleTex2DFlowDynamic              | Samples the provided texture using the dynamic flow mapping technique. |
| SampleTex2DFlowStatic               | Samples the provided texture using the static flow mapping technique. |
| SampleVelocity                      | Samples the fluid simulation's velocity data. |
| UVToBorderMask                      | Convert the UV into a soft border fading to black on the edges. |
| UVToBorderMaskInverted              | Convert the UV into a soft border fading to white on the edges. |

#### Terraform Terrain Nodes

| Node                                  | Description                                      |
|---------------------------------------|--------------------------------------------------|
| SampleHeightMap                    | Samples the Terraform Terrain Heightmap. |
| SampleLayers                      | Samples and blends all the layers of the Terraform Terrain shader based on the splatmap mask. |

#### Particle Nodes

| Node                                  | Description                                      |
|---------------------------------------|--------------------------------------------------|
| SampleParticleData                    | Samples the particle simulation's graphics buffer to retrieve it's data. |
| SampleParticleVertexData              | Sample the vertex position's of the particle. |
| TransformParticleToBillboard          | Transform the particle and particle vertex data into a billboard. |

---

<div style="page-break-after: always;"></div>

<a name="tiled-simulation"></a>
