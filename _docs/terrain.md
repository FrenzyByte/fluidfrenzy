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

##### **Mesh Rendering**
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

##### **Terrain Settings**
- **Height Scale** - adjusts the overall height of the terrain by applying a multiplier to both the red and green channels of the Source Heightmap.
- **Terrain Material** - is the material the terrain will be rendered with. Currently, only the **Simple Terrain** and **Terraform Terrain** shaders are supported. Custom shaders can be written.
- **Terrain Heightmap** - specifies the heightmap applied to the terrain with the red channel representing base height and the green channel showing erodible layers above it. Using a 16-bit per channel texture is recommended to avoid artifacts like stepping or terracing.
- **Upsample** - Upsample the heightmap using interpolation to increase the number of samples and reduce precision artifacts, especially when using low bit-depth source heightmaps.
- **Shadow Light** - is used to perform a main shadow culling pass on the GPULOD Terrain to accelerated shadow rendering.

##### **Collision**
- **Create Collider** - toggles the generation of a TerrainCollider to use for physics.
- **Resolution** - the quality of the TerrainCollider grid. Higher resolutions means more accurate physics, at the cost of longer generation times. Internally the grids resolution is resolution+1.
- **Update Realtime** - update the collider in real time every Nth frame to match the collider with the rendered data. Updating the collider requires the GPU terrain data to be read back to the CPU and applied to the TerrainData this can be expensive.
- **Frequency** - update the collider in real time every Nth frame to match the collider with the rendered data. Updating the collider requires the GPU terrain data to be read back to the CPU and applied to the TerrainData, which can be resource-intensive.
- **Timeslice** - splits the update of the heightmap in several segments. Each segment will be rendered on a different frame. A full collider update takes this many frames.

##### **Saving and Loading (BETA)**
<sub>**This functionality is subject to future changes.**</sub>

The state of the terrain can both be saved and loaded back in by using the **SaveTerrain** and **LoadTerrain**. The result can be saved and loaded as a [.exr*](https://openexr.com/en/latest/) or [.png](https://en.wikipedia.org/wiki/PNG). The functionality is also exposed in the editor for testing purposes.

Parameters:
- *directory* - the directory where the file will be saved to/loaded from.
- *filename* - the name of the file to save/load.
- *format* - the format to save/load. Currently only exr and png is supported.


<sub>* Loading .exr files is only available from Unity 6 and onward due to no functionality existing in older versions.</sub>

<a name="terraform-terrain"></a>
#### Terraform Terrain
The **Terraform Terrain** component is an extension of the **Simple Terrain** component. It adds an extra [splat map](https://en.wikipedia.org/wiki/Texture_splatting) that the [Terraform Layer](../fluid_simulation_components#terraform-layer) makes modifications to. This splat map is used to represent different terrain layers on the base layer of the terrain. It is rendered by the **FluidFrenzy/TerraformTerrain** or **FluidFrenzy/TerraformTerrain(Single Layer) shader.

![Terraform Terrain](../../assets/images/terraformterrain.png)

- **Splatmap** - is applied to the Terraformed terrain as a mask to determine which layer of textures and material properties of the assigned **Terrain Material** to use. The splat map is only applied to the base(R) layer.
Each channel in the splatmap corresponds to a layer of the **Terrain Material**.
    - Layer 1: red
    - Layer 2: green
    - Layer 3: blue
    - Layer 4: alpha

<a name="terraform-terrain-shader"></a>
#### Terraform Terrain Shader

![alt text](../../assets/images/terraformterrain_mutilayer.png)

The Terraform Terrain shader is used to render the terrain. It organizes textures into two main groups: **Splat Layers** and **Dynamic Layers**. Both groups are fully terraformable.

This shader requires **Texture2DArray** assets for its texture slots. You can create these assets using the **Window > Fluid Frenzy Texture Array Creator** tool.

##### Splat Layers (R)
This section defines the four base terrain layers. They are blended together using the RGBA channels of the splatmap to create ground variation. These layers are fully terraformable.

- **Albedo** - The Texture2DArray containing the base color textures for the four splat layers.
- **Mask Map** - The Texture2DArray containing data for Metallic (R), Occlusion (G), and Smoothness (A).
- **Normal Map** - The Texture2DArray for the splat layers' normal maps.

##### Dynamic Layers
These three layers are intended for terraformable materials like mud, sand, or snow, which can be transformed into other layers during gameplay. They use a separate set of Texture2DArray assets.

- **Albedo** - The Texture2DArray for the base color of the three dynamic layers.
- **Mask Map** - The Texture2DArray for the dynamic layers' mask maps.
- **Normal Map** - The Texture2DArray for the dynamic layers' normal maps.

##### Layer Settings
This section provides a grid to override properties for each of the 7 terrain layers (4 Splat Layers and 3 Dynamic Layers). This allows you to adjust the look of each material without creating new textures.

- **Layer Tint** - A color multiplier applied to each base layer's albedo.
- **Tiling / Offset** - Controls the UV scale and position for each layer's textures.
- **Normal Scale** - Adjusts the intensity of the normal map for each layer.


<a name="terraform-terrain-single-shader"></a>
#### Terraform Terrain (Single Layer) Shader
The Terraform Terrain (Single Layer) shader is a cheaper version of the Terraform Terrain shader and handles the rendering of the Terraform Terrain. It has layers with texture slots for rendering the layers of the terrain. The height of these layers 1 to 4 is controlled by the heightmap's red channel. The heightmap and splatmap(RGBA) can be modified manually or by the **Terraform Terrain Layer** due to fluid mixing. Each layer corresponds to a channel in the splatmap as described above. The **Top/Erosion Layer** has a fixed color layer that cannot have its appearance changed as the visibility and height is controlled by the heightmap's green channel.

![alt text](../../assets/images/terraformterrain_shader.png)

- **Albedo** - albedo texture and color(multiplier) of the layer
- **Normal Map** - normal map of the layer
- **Mask Map** - metallic(R), occlusion(G), smoothness(A) of the layer.

---

<div style="page-break-after: always;"></div>

<a name="fluid-modifiers"></a>
