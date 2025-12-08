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

A specialized terrain rendering component designed for the [Fluid Simulation](../fluid_simulation_components#fluid-simulation) system, capable of supporting real-time modifications from an [Erosion Layer](../fluid_simulation_components#erosion-layer).

Unlike a Unity Terrain, `SimpleTerrain` allows for dynamic updates to its heightmap data directly on the GPU. When an [Erosion Layer](../fluid_simulation_components#erosion-layer) is active, sediment transport and deposition changes are applied to this terrain instantly.

![Simple Terrain](../../assets/images/simpleterrain.png)

##### **Terrain Settings**

| Property | Description |
| :--- | :--- |
| Terrain Material | The material used to render the terrain surface.<br/><br/>The assigned shader must support vertex displacement based on the **Render Heightmap** to correctly visualize the terrain shape. |
| [Surface Properties](../fluid_rendering_components#render-properties) | Configuration settings that determine the visual quality, resolution, and rendering method (e.g., MeshRenderer vs. GPULOD) of the terrain. |
| Source Heightmap | The input texture that defines the initial shape and composition of the terrain.<br/><br/>For best results, use a 16-bit (16bpp) texture to prevent stepping artifacts. <br/><br/> The texture channels represent distinct material layers stacked sequentially from bottom to top. All layers are erodible.  <br/>-  **`Red Channel`**  Layer 1 (Bottom). Defines the base height. In `TerraformTerrain`, a separate splatmap texture is used to apply visual variation to this specific layer.  <br/>-  **`Green Channel`**  Layer 2. Stacked on top of the Red channel.  <br/>-  **`Blue Channel`**  Layer 3. Stacked on top of the Green channel.  <br/>-  **`Alpha Channel`**  Layer 4 (Top). Stacked on top of the Blue channel. |
| Height Scale | A global multiplier applied to the height values sampled from the [Source Heightmap](#source-heightmap).<br/><br/>This converts the normalized (0 to 1) texture data into world-space height units. |
| Upsample | Toggles bilinear interpolation for the heightmap sampling.<br/><br/>Enabling this increases the number of samples taken to smooth out the terrain. This is particularly useful for reducing "stair-stepping" artifacts when using lower bit-depth source textures. |
| Shadow Light | The primary directional light used to calculate shadows on the terrain.<br/><br/>This is primarily used when rendering in the Built-in Render Pipeline (BiRP) to manually handle shadow projection on the custom terrain mesh. |
| [Collider Properties](../physics_colliders#collider-properties) | Configuration settings for generating the physical [Terrain Collider](https://docs.unity3d.com/ScriptReference/TerrainCollider.html) associated with this terrain. |

##### **Mesh Rendering**
| Property | Description |
| :--- | :--- |
| Render Mode | The method used for generating and rendering the fluid surface geometry.<br/><br/>-  **`MeshRenderer`**  Uses standard GameObjects with [Mesh Renderer](https://docs.unity3d.com/ScriptReference/MeshRenderer.html) components. Best for simple setups where standard object culling is sufficient.  <br/>-  **`DrawMesh`**  Uses [Render Mesh](#render-mesh) to avoid GameObject overhead. Supports GPU Instancing.  <br/>-  **`GPULOD`**  Draws the surface using a GPU-accelerated LOD system. Best for large-scale oceans or lakes.  <br/>-  **`HDRPWaterSurface`**  Bridges the simulation data to a Unity [HDRP Water Surface](../fluid_rendering_components#hdrp-water-surface) component (Requires HDRP). |
| Dimension | The total world-space size (X and Z) of the rendered surface. |
| Mesh Resolution | The vertex resolution of the surface's base grid mesh.<br/><br/>For the most accurate visualization, it is recommended to match this value to the source heightmap resolution. |
| Mesh Blocks | The number of subdivisions (blocks) to split the rendering mesh into along the X and Z axes.<br/><br/>Subdividing the mesh improves GPU performance by allowing the camera to cull blocks that are outside the view frustum. |
| Lod Resolution | The vertex resolution of individual LOD patches when using **GPULOD**. |
| Traverse Iterations | The number of iterations the Quadtree traversal algorithm performs per frame when using **GPULOD**.<br/><br/>Higher values resolve the surface quality faster during camera movement but may reduce performance. |
| Lod Min Max | The range of allowable LOD levels, where X is the minimum level and Y is the maximum level. |

##### **Collision**

| Property | Description |
| :--- | :--- |
| Create Collider | Toggles the generation of a [Terrain Collider](https://docs.unity3d.com/ScriptReference/TerrainCollider.html) to handle physical interactions with the fluid surface. |
| Resolution | Specifies the grid resolution of the generated [Terrain Collider](https://docs.unity3d.com/ScriptReference/TerrainCollider.html).<br/><br/>This value determines the density of the physics mesh. Higher resolutions result in more accurate physical interactions but increase generation time and physics processing overhead. <br/><br/> Internally, the actual grid size is set to `resolution + 1` to satisfy heightmap requirements. |
| Realtime | Controls whether the collider's heightmap is updated at runtime to match the visual fluid simulation.<br/><br/>When enabled, the simulation data is continuously synchronized with the physics collider. Note that this process requires reading GPU terrain data back to the CPU and applying it to the **Terrain Data**, which can be resource-intensive and cause garbage collection spikes. |
| Update Frequency | The interval, in frames, between consecutive collider updates when [Realtime](#realtime) is enabled.<br/><br/>Increasing this value reduces the performance cost of the readback but causes the physics representation to lag behind the visual rendering. |
| Timeslicing | The number of frames over which a single full collider update is distributed.<br/><br/>This feature splits the heightmap update into smaller segments, processing only a fraction of the data per frame. This helps to smooth out performance spikes and maintain a stable framerate, though it increases the time required for the collider to fully reflect a change in the fluid surface. |

##### **Saving and Loading**
The state of the terrain and fluid simulation can both be saved and loaded back in by using the SaveTerrain and LoadTerrain methods (or equivalent editor functions).

The simulation state is saved as a collection of textures (e.g., height map, velocity, pressure). Each texture can be saved and loaded using one of two formats, managed by the new SimulationIO utility:

    RAW (.data): The recommended, high-fidelity format. This custom format is fast, lossless, and is essential for saving high-precision simulation data (e.g., floating-point textures). It supports optional GZip compression and embedding texture metadata directly within the file.

    PNG (.png): A standard image format. While useful for visual debugging, it is lossy and is not recommended for saving the full, high-precision simulation state.

The functionality is also exposed in the editor for testing purposes.

<a name="terraform-terrain"></a>
#### Terraform Terrain
The **Terraform Terrain** component is an extension of the **Simple Terrain** component. It adds an extra [splat map](https://en.wikipedia.org/wiki/Texture_splatting) that the [Terraform Layer](../fluid_simulation_components#terraform-layer) makes modifications to. This splat map is used to represent different terrain layers on the base layer of the terrain. It is rendered by the **FluidFrenzy/TerraformTerrain** or **FluidFrenzy/TerraformTerrain(Single Layer) shader.

![Terraform Terrain](../../assets/images/terraformterrain.png)

| Property | Description |
| :--- | :--- |
| Splatmap | The texture defining the initial material distribution (splatmap) across the terrain surface.<br/><br/>The splat map acts as a mask to determine which of the four material layers from the assigned [Terrain Material](#terrain-material) are rendered at any given coordinate. Each channel of the splat map corresponds to a material layer:  <br/>- Layer 1: Red channel (Primary Material) <br/>- Layer 2: Green channel <br/>- Layer 3: Blue channel <br/>- Layer 4: Alpha channel  **Crucial Constraint:** When using `TerraformTerrain`, this splat map is only applied to the base (Red channel) physical layer data defined by the [Source Heightmap](#source-heightmap). The other physical layers (G, B, A channels of the heightmap) use their respective material properties directly without being masked by this splat map. |

<a name="terraform-terrain-shader"></a>
#### Terraform Terrain Shader

A multi-layered, texture-array-driven surface shader designed to render a terrain that is fully compatible with Fluid Frenzy's terraforming capabilities.

This shader requires **Texture2DArray** assets for its texture slots. These assets can be created using the **Window > Fluid Frenzy Texture Array Creator** tool.

The shader organizes its texture inputs into two primary, fully terraformable groups: Splat Layers and Dynamic Layers.

Splat Layers (R):
Defines the four base layers, blended by a Splatmap (RGBA).

Dynamic Layers:
Three additional layers for dynamic, transformable materials (mud, sand, snow).

Layer Overrides:
Allows per-layer adjustments across all seven layers, including Layer Tint, Tiling / Offset, and Normal Scale, without modifying source textures.

Compatibility:
The FluidFrenzy/TerraformTerrain shader is for URP and BiRP. The High Definition Render Pipeline (HDRP) requires a separate, dedicated shader: FluidFrenzy/HDRP/TerraformTerrain.

![alt text](../../assets/images/terraformterrain_mutilayer.png)

##### Splat Layers (R)
This section defines the four base terrain layers. They are blended together using the RGBA channels of the splatmap to create ground variation. These layers are fully terraformable.

| Property | Description |
| :--- | :--- |
| Albedo | Texture2DArray for Albedo (RGB). |
| Mask Map | Texture2DArray for Metallic (R), Occlusion (G), and Smoothness (A). |
| Normal Map | Texture2DArray for Normal Maps. |

##### Dynamic Layers
These three layers are intended for terraformable materials like mud, sand, or snow, which can be transformed into other layers during gameplay. They use a separate set of Texture2DArray assets.

| Property | Description |
| :--- | :--- |
| Albedo | Texture2DArray for Albedo (RGB). |
| Mask Map | Texture2DArray for Metallic (R), Occlusion (G), and Smoothness (A). |
| Normal Map | Texture2DArray for Normal Maps. |

##### Layer Settings
This section provides a grid to override properties for each of the 7 terrain layers (4 Splat Layers and 3 Dynamic Layers). This allows you to adjust the look of each material without creating new textures.

| Property | Description |
| :--- | :--- |
| Layer Tint | A color multiplier for each layer's albedo. |
| Tiling | The UV tiling (XY) for each layer. |
| Offset | The UV offset (ZW) for each layer. |
| Normal Scale | Per-layer scale for each of the Layer normal maps. |

<a name="terraform-terrain-single-shader"></a>
#### Terraform Terrain (Single Layer) Shader
The Terraform Terrain (Single Layer) shader is a cheaper version of the Terraform Terrain shader and handles the rendering of the Terraform Terrain. It has layers with texture slots for rendering the layers of the terrain. The height of these layers 1 to 4 is controlled by the heightmap's red channel. The heightmap and splatmap(RGBA) can be modified manually or by the **Terraform Terrain Layer** due to fluid mixing. Each layer corresponds to a channel in the splatmap as described above. The **Top/Erosion Layer** has a fixed color layer that cannot have its appearance changed as the visibility and height is controlled by the heightmap's green channel.

![alt text](../../assets/images/terraformterrain_shader.png)

| Property | Description |
| :--- | :--- |
| Albedo | albedo texture and color(multiplier) of the layer |
| Normal Map | normal map of the layer |
| Mask Map | metallic(R), occlusion(G), smoothness(A) of the layer. |

---

<div style="page-break-after: always;"></div>

<a name="fluid-modifier"></a>
