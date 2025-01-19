---
title: Fluid Rendering Components
permalink: /docs/fluid_rendering_components/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

The **FluidRenderer** component is responsible for rendering the Fluid Simulation. This component is in charge of creating and rendering the necessary meshes and materials needed for displaying the assigned Fluid Simulation. Users can customize the **FluidRenderer** component to create their own rendering effects, similar to **WaterSurface** and **LavaSurface** renderers.

- **Render Mode** - The method used for rendering the surface.

    - **MeshRenderer**: Uses GameObjects with [MeshRenderer](https://docs.unity3d.com/ScriptReference/MeshRenderer.html) components to draw the surface. The surface is a evenly distributed fixed size grid. The grid can be split up into multiple blocks/objects for better culling. GPU instancing is supported when enabled on the assigned material. 

    - **DrawMesh**: Uses [Graphics.RenderMesh](https://docs.unity3d.com/ScriptReference/Graphics.RenderMesh.html) or [Graphics.RenderMeshInstanced](https://docs.unity3d.com/ScriptReference/Graphics.RenderMeshInstanced.html) to render a height field to each camera, it has the same functionality as the MeshRenderer method except it doesn't create any GameObjects and it is rendered manually and can therefore support GPU Instancing on the water shader.

    - **GPULOD**: Draws the surface using a fully [GPU-Accelerated distance based LOD system](https://www.researchgate.net/publication/331761994_Quadtrees_on_the_GPU) for maximum performance. The surfaces will be drawn with higher detail up close, and lower detail in the distance.
- **Mesh Resolution** - the amount of vertices the mesh is in each axis. It is best to match **Fluid Simulation Settings -** **Number of Cells**.
- **Mesh Blocks** - the amount of blocks the rendering mesh is to be subdivided in to improve GPU performance by culling parts of the renderer.
- **LOD Resolution** - The resolution of each LOD mesh in the terrain.
- **Traverse Iterations** - The number of iterations the GPULOD Quadtree will run when traversing the Quadtree. Higher iterations resolve the quality of the surface faster, but reduces performance.
- **LOD Levels** - The minimum and maximum LOD levels that can be selected.
- **Fluid Material** - is the material the fluid simulation will be rendered with.
- **Simulation** - is the simulation to be rendered.
- **Flow Mapping** - the **Flow Mapping Layer** component whose rendering data will be used to apply flow mapping to the material.
___

<a name="water"></a>
### Water

<a name="water-surface"></a>
#### Water Surface

![Water Surface](../../assets/images/watersurface.png)

[Water Surface](#water-surface) is an extension of the [FluidRenderer](../fluid_simulation_components#fluid-rendering-components) component that specifically deals with rendering water-related elements of the fluid simulation, such as foam. It accomplishes this by assigning the currently active rendering layers to its assigned material.

- **Foam Layer** - assign a [Foam Layer](../fluid_simulation_components#foam-layer) component whose foam mask to apply for foam rendering effects on the water material.

<div style="page-break-after: always;"></div>

<a name="water-shader"></a>
#### Water Shader

**FluidFrenzy/Water** is the shader that is applied to the materials on the [Water Surface](#water-surface) **Fluid Material** field.
There are a lot of material properties available for tweaking to create beautiful-looking water.

##### Lighting

Lighting effect rendering properties

![Water Shader](../../assets/images/watershader_slice_0_0.png)

- **Specular Intensity** - increase/decrease the specular light brightness of the main directional light.
- **Shadows** - enables/disables if the water receives shadows.

##### Reflection

Water's reflection rendering properties.

![Water Shader](../../assets/images/watershader_slice_1_0.png)

- **Planar Reflection** - enables/disables if the water should use planar reflections or just reflection probes.
- **Distortion** - scales the distortion applied to the planar reflections.

##### Absorption

Depth-based control of the water's color and refraction rendering properties. 

![Water Shader](../../assets/images/watershader_slice_2_0.png)

- **Color** 
    - *RGB* - is the color of the water at the maximum depth.
    - *Alpha* - is the base transparency of the water. Any value below 255 will make your water always transparent regardless of depth.
- **Depth Transparency** - scales how transparent the water is based on the depth. Lower values make the water more transparent.
- **Screenspace Refraction** - *enabled:* uses screenspace refraction by using GrabPass to sample what is behind the water, using this allows you to use distortion. *Disabled:* uses alpha blending to simulate water transparency. 
*URP*: Requires rendering features to be enabled as described [here](../setup#setup-urp).
- **Distortion** - scales the distortion of the screenspace refraction when enabled.

##### Subsurface scattering

Subsurface scattering rendering effect properties

![Water Shader](../../assets/images/watershader_slice_3_0.png)

- **Color** - the color the water will become when a condition for subsurface scattering is met.
- **Intensity** - scales the base intensity of the subsurface scattering.
- **Light Contribution** - scales the contribution of subsurface scattering when the water is facing away from the light.
- **View Contribution** - scales the contribution of subsurface scattering when the water is facing toward the observer.
- **Foam Contribution** - scales the contribution of subsurface scattering when there is foam in the water.
- **Ambient** - scales the base contribution that can be used to always have some subsurface scattering no matter the contribution of the previous parameters.

##### Waves

Render quality improvements by applying detail waves using normal mapping and displacement mapping.

![Water Shader](../../assets/images/watershader_slice_4_0.png)

- **Normal map** - texture, strength, and tiling options to apply extra detail normals to the water surface. 
- **Vertex Displacement** - applies small displacement waves to the vertices based on the velocity within the velocity field of the fluid simulation.
    - *Tiling* - scales the amount of displacement waves.
    - *Wave Amplitude* - scales the height of the displacement waves.
    - *Wave Speed* - scales the movement speed of the displacement waves.
    - *Wave Length* - scales the size/distance between the displacement waves.
    - *Wave Steepness* - scales the sharpness/smoothness of the displacement waves.
    - *Phase Speed* - scales how fast the waves move up and down.

##### Foam

Foam rendering effect properties.

![Water Shader](../../assets/images/watershader_slice_5_0.png)

- **Foam Albedo** - a texture(RGB) multiplied by the color picker(RGB) is used as the diffuse color of the foam. The texture(A)  multiplied by the color picker(A) is used as a mask on where to apply the foam.
- **Foam Normal Map** - a texture used to add detail to the PBR lighting of the foam.
- **Tiling** - tiles the **Foam Albedo** and **Foam Normal Map** textures.
- **Offset** - offsets the **Foam Albedo** and **Foam Normal Map** textures.
- **Foam Visibility Range** - sets the minimum and maximum values when the foam becomes visible and reaches its maximum strength. The visibility of the foam is determined by the Foam Layer mask multiplied by the Foam Albedo Alpha. Any values below the minimum result in no foam, while values above the maximum apply the full amount of foam. Interpolation between the minimum and maximum values is done using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).

##### Rendering

General rendering settings.

![Water Shader](../../assets/images/watershader_slice_6_0.png)

- **Layer** - which layer from the Fluid Simulation to use.
- **Render Queue** - the rendering order of the material.

___
<div style="page-break-after: always;"></div>

<a name="lava"></a>
### Lava

<a name="lava-surface"></a>
#### Lava Surface
**LavaSurface** is an extension of the [FluidRenderer](../fluid_simulation_components#fluid-rendering-components) component. It is modified to allow the generation of a custom heat LUT through its gradient field. This LUT is assigned to the Lava material to determine the emissive color of lava based on factors like the velocity of the lava.

![Lava Surface](../../assets/images/lavasurface.png)

- **Generate Heat LUT** - when enabled the **Heat Gradient** configured will override the *Heat LUT* applied to the **Fluid Material** with a *procedurally generated texture*.
- **Heat Gradient** - The gradient that will be used to generate a LUT for sampling the heat of the lava. Cold Lava(Left), Hot Lava(Right).

<a name="lava-shader"></a>
#### Lava Shader

**FluidFrenzy/Lava** is the shader that is applied to the materials on the [Lava Surface](#lava-surface) **Fluid Material** field. The *heat* of the lava is the length of the velocity vector in the velocity field.

![Lava Shader](../../assets/images/lavashader.png)

- **Heat LUT** - is a gradient texture used to determine the color of the lava emission based on the *heat* of the lava.
- **Heat LUT Scale** - is a scale applied to the *heat* when sampling the **Heat LUT** gradient.
- **Albedo** - is the albedo texture of the lava. This is what cold lava will look like.
- **Smoothness Scale** - is the PBR smoothness of the cold lava surface.
- **Normal Map** - this is the normal map for more detailed lighting applied to the cold lava surface.
- **Emission Map** - is a texture used for the emission color of the lava. The sample of this texture is multiplied by the *heat*. 
- **Emission** - is the intensity of the **Heat LUT** sampled based on the **Emission Map** and *heat*.
- **Noise** - a texture used to eliminate tiling from the lava textures.

___

<a name="terrain"></a>
