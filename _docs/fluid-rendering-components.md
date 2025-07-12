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
    - **HDRP Water System**: Use the [HDRP Water System](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@14.0/manual/WaterSystem-use.html) by combining the **Fluid Simulation** with the input for the water system. More information can be found [here](#hdrp-water-system).
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

- **Reflectivity Offset** - offset the reflectiveness of the water surface. Use this if the water should be reflective even when at sharp angles.
- **Planar Reflection** - enables/disables if the water should use planar reflections or just reflection probes.
- **Distortion** - scales the distortion applied to the planar reflections.

##### Absorption

Depth-based control of the water's color and refraction rendering properties. 

![Water Shader](../../assets/images/watershader_slice_2_0.png)

- **Color** 
    - *RGB* - is the color of the water at the maximum depth.
    - *Alpha* - is the base transparency of the water. Any value below 255 will make your water always transparent regardless of depth.
- **Depth Transparency** - scales how transparent the water is based on the depth. Lower values make the water more transparent.
- **Refraction Mode** - 
    - *Screenspace Tint:* uses screenspace refraction by using GrabPass to sample what is behind the water, using this allows you to use distortion. The water color is interpolated from clear to the selected color depending on the depth. Use this feature if you want a single color
    - *Screenspace Absorb:* uses screenspace refraction by using GrabPass to sample what is behind the water, using this allows you to use distortion. The water color used to multiply the scene color. Use this feature if you want the color gradient to change from blue to clear with different tings like green in between, depending on the depth, similar how the water at a beach tropical beach behaves.
    *URP*: Requires rendering features to be enabled as described [here](../setup#setup-urp).
    - *Alpha:* uses alpha blending to simulate water transparency. 
    - *Opaque:* water is rendered as solid. 
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

- **Screenspace Particles** - enable the use of the [Offscreen Rendered particles](../fluid_simulation_components#particle-generator) as a foam mask.
- **Foam Mode** - select the mode the **Foam Map** foam map is used for rendering.
    - *Albedo:* - use the **Foam Map** and the selected color directly as the albedo color. This method gives soft foam.
    - *Clip:* - use the **Foam Map's** red channel and selected color's alpha channel as a clip value, any value in the **Foam Layers** that is lower than this clip value will not be drawn. The color from the color picker is used as the color of the foam. This method gives foam with hard edges.
    - *Mask:* - use the **Foam Map's** RGB channels as a extra mask to be applied to the **Foam Layer Mask**. Any values between 0 and 0.334 will use the blue channel as a mask, 0.334 and 0.667 will use the green channel as a mask, and 0.667 and 1 will use the red channel as a mask. This mask is then used to blend the foam color onto the water. Use this if you want variation in foam intensity.
- **Foam Map** - a texture(RGB) multiplied by the color picker(RGB) is used as the diffuse color of the foam. The texture(A)  multiplied by the color picker(A) is used as a mask on where to apply the foam.
- **Foam Normal Map** - a texture used to add detail to the PBR lighting of the foam.
- **Tiling** - tiles the **Foam Albedo** and **Foam Normal Map** textures.
- **Offset** - offsets the **Foam Albedo** and **Foam Normal Map** textures.
- **Foam Visibility Range** - sets the minimum and maximum values when the foam becomes visible and reaches its maximum strength. The visibility of the foam is determined by the Foam Layer mask multiplied by the Foam Albedo Alpha. Any values below the minimum result in no foam, while values above the maximum apply the full amount of foam. Interpolation between the minimum and maximum values is done using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).

##### Rendering

General rendering settings.

![Water Shader](../../assets/images/watershader_slice_6_0.png)

- **Layer** - which layer from the Fluid Simulation to use.
- **Render Queue** - the rendering order of the material.

<a name="water-planar-reflections"></a>
#### Planar Reflections
The PlanarReflections component can be added to the water to enhance the rendering quality by adding reflections. This is achieved by rendering the scene again flipped around the water plane. 
The PlanarReflections script reads the height of the fluid simulation to try and match the height as best as possible and smooths out the height to prevent quick jittering changes due to small waves.  

![planar_reflections](../../assets/images/planar_reflections.png)

The following settings can be configured to setup the Planar reflections:

- **Culling Mask** - which layers the planar reflections render
- **Clear Flags** - what to display in empty areas of the planar reflection's view.
- **Resolution** - the quality of the planar reflections
- **Clip Plane** - a offset to apply to the sampled simulation's height.
- **Height Sample Transform** - override the location to use for sampling the height of the simulation.
- **Smooth Position** - smooths the sampling height and position over multiple frames to prevent planar reflections jittering as the fluid simulation updates.

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

<a name="particle-shaders"></a>
### Particles
The particles in **Fluid Frenzy** are completely GPU accelerated and therefore require a custom shader to be rendered. Currently there is the selection of two shaders *ProceduralParticle* and *ProceduralParticleUnlit*. Both shaders will render the particles as billboards, however the Unlit version will not do any lighting and is therefore cheaper to render.

![Particle Shader](../../assets/images/particle_shader.png)

- **Color** - is the albedo color and transparency of the particle.
- **Normal Map** - can be used to add extra lighting details to the *ProceduralParticle* shader.
- **Metallic** - the metalness of the material.
- **Smoothness** - the smoothness of the material.
- **Blend Mode** - select which [blend mode](https://en.wikipedia.org/wiki/Blend_modes) to use for the particles.
- **Alpha Threshold** - alpha below this value will be clipped.
- **Billboard Mode** - select which method to use for rendering the particle billboard.
    - *Camera:* the billboard and world normal will face in the direction of the camera.
    - *Camera Normal Up:* the billboard will face the camera and the normal will face in in the world space up direction. This can be useful to have more uniform lighting from every direction.
    - *Up:* the billboard and normal will both face in the world space up direction.
    - *Normal:* not yet implemented. 

<a name="shadow-grabber"></a>
### Shadows
Both the Water and Lava is rendered after any opaque layers to allow for refraction and to prevent sorting issues. This means that in the Built-in Render pipeline shadows are not automatically sampled due to the transparent nature of the rendering. In order to solve this the user can add he **ShadowGrabber** component to the **Main Directional Light** in the scene. This will assign the shadow buffer to global shader property so that the Water and Lava shader can read it. In order for a material to read it the Shadows property on the Material needs to be set to either *Hard* or *Soft*.

<a name="hdrp-water-system"></a>
### HDRP Water System
Fluid Frenzy has the ability to apply the Fluid Simulation's data to the [HDRP Water System](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@14.0/manual/WaterSystem-use.html). This allows the user to enhance their HDRP scene without sacrificing the quality HDRP provides.

To support this the user will have to enable decal support in their HDRP Quality settings:
![alt text](../../assets/images/hdrp_settings_decal.png)

The displacement and flowmapping of the Fluid Simulation is applied using the [Water Decal](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@17.1/manual/water-deform-a-water-surface.html) system, which is automatically created when setting the [Water Surface](#water-surface) to the **HDRP Water System** mode.
The Water Decal system uses signed normalized render buffers to apply the displacement, which requires a amplitude to be applied to the decal. This amplitude is the maximum height the simulation will be able to displace the water surface.

![alt text](../../assets/images/hdrp_watersurface_settings.png)

- **Target Water Surface** - defines the HDRP Water System to which the simulation is to be applied.
- **Amplitude** - is the maximum amplitude of the Fluid Simulation used to encode/decode the height to/from 0-1 range.
- **Large Current** - is the weight that the Fluid Simulation's velocity should be applied to the Large Current waves of the HDRP Water System. 
- **Ripples** - is the weight that the Fluid Simulation's velocity should be applied to the Rupples of the HDRP Water System. 
___

<a name="terrain"></a>
