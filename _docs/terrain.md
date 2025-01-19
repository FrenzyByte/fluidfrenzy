---
title: Terrain
permalink: /docs/terrain/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

Fluid Frenzy has the capability to render terrain height maps using a custom terrain system. 
Currently features for terrains are limited but consists of the following:

1. LOD
2. Splatmapping
3. Terraforming
4. Collision

<a name="simple-terrain"></a>
#### Simple Terrain

**Simple Terrain** is a terrain rendering component for fluid simulations that makes use of the [Erosion Layer](../fluid_simulation_components#erosion-layer). When the [Erosion Layer](../fluid_simulation_components#erosion-layer) makes modifications to the terrain height it is applied directly to the **Simple Terrain** in realtime.

![Simple Terrain](../../assets/images/simpleterrain.png)

##### Mesh Rendering
- **Rendering Mode** - The method used for rendering the surface.

    - **MeshRenderer**: Uses GameObjects with [MeshRenderer](https://docs.unity3d.com/ScriptReference/MeshRenderer.html) components to draw the surface. The surface is a evenly distributed fixed size grid. The grid can be split up into multiple blocks/objects for better culling. GPU instancing is supported when enabled on the assigned material. 

    - **DrawMesh**: Uses [Graphics.RenderMesh](https://docs.unity3d.com/ScriptReference/Graphics.RenderMesh.html) or [Graphics.RenderMeshInstanced](https://docs.unity3d.com/ScriptReference/Graphics.RenderMeshInstanced.html) to render a height field to each camera, it has the same functionality as the MeshRenderer method except it doesn't create any GameObjects and it is rendered manually and can therefore support GPU Instancing on the water shader.

    - **GPULOD**: Draws the surface using a fully [GPU-Accelerated distance based LOD system](https://www.researchgate.net/publication/331761994_Quadtrees_on_the_GPU) for maximum performance. The surfaces will be drawn with higher detail up close, and lower detail in the distance.
- **Mesh Resolution** - the amount of vertices the mesh is in each axis. It is best to match **Fluid Simulation Settings -** **Number of Cells**.
- **Mesh Blocks** - the amount of blocks the rendering mesh is to be subdivided in to improve GPU performance by culling parts of the renderer.
- **LOD Resolution** - The resolution of each LOD mesh in the terrain.
- **Traverse Iterations** - The number of iterations the GPULOD Quadtree will run when traversing the Quadtree. Higher iterations resolve the quality of the surface faster, but reduces performance.
- **LOD Levels** - The minimum and maximum LOD levels that can be selected.
- **Dimension** - determines the width and height of the terrain.

##### Terrain Settings
- **Height Scale** - adjusts the overall height of the terrain by applying a multiplier to both the red and green channels of the Source Heightmap.
- **Terrain Material** - is the material the terrain will be rendered with. Currently, only the **Simple Terrain** and **Terraform Terrain** shaders are supported. Custom shaders can be written.
- **Terrain Heightmap** - specifies the heightmap applied to the terrain with the red channel representing base height and the green channel showing erodible layers above it. Using a 16-bit per channel texture is recommended to avoid artifacts like stepping or terracing.
- **Shadow Light** - is used to perform a main shadow culling pass on the GPULOD Terrain to accelerated shadow rendering.

##### Collision
- **Create Collider** - toggles the generation of a TerrainCollider to use for physics.
- **Resolution** - the quality of the TerrainCollider grid. Higher resolutions means more accurate physics, at the cost of longer generation times. Internally the grids resolution is resolution+1.
- **Update Realtime** - update the collider in real time every Nth frame to match the collider with the rendered data. Updating the collider requires the GPU terrain data to be read back to the CPU and applied to the TerrainData this can be expensive.
- **Frequency** - update the collider in real time every Nth frame to match the collider with the rendered data. Updating the collider requires the GPU terrain data to be read back to the CPU and applied to the TerrainData, which can be resource-intensive.
- **Timeslice** - splits the update of the heightmap in several segments. Each segment will be rendered on a different frame. A full collider update takes this many frames.


<a name="terraform-terrain"></a>
#### Terraform Terrain
The **Terraform Terrain** component is an extension of the **Simple Terrain** component. It adds an extra [splat map](https://en.wikipedia.org/wiki/Texture_splatting) that the [Terraform Layer](../fluid_simulation_components#terraform-layer) makes modifications to. This splat map is used to represent different terrain layers on the base layer of the terrain. It is rendered by the **FluidFrenzy/TerraformTerrain** shader.

![Terraform Terrain](../../assets/images/terraformterrain.png)

- **Splatmap** - is applied to the Terraformed terrain as a mask to determine which layer of textures and material properties of the assigned **Terrain Material** to use. The splat map is only applied to the base layer since there is only 1 erodible material.
Each channel in the splatmap corresponds to a layer of the **Terrain Material**.
    - Layer 1: red
    - Layer 2: green
    - Layer 3: blue **(Not implemented yet)**
    - Layer 4: alpha **(Not implemented yet)**
---

<div style="page-break-after: always;"></div>

<a name="fluid-modifiers"></a>
