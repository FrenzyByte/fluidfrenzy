---
title: Fluid Rendering Components
permalink: /docs/fluid_rendering_components/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

<a name="fluid-renderer"></a>
### Fluid Renderer

The [Fluid Renderer](#fluid-renderer) component is responsible for rendering the [Fluid Simulation](../fluid_simulation_components#fluid-simulation). This component is in charge of creating and rendering the necessary meshes and materials needed for displaying the assigned [Fluid Simulation](../fluid_simulation_components#fluid-simulation). Users can customize the [Fluid Renderer](#fluid-renderer) component to create their own rendering effects, similar to [Water Surface](#water-surface) and [Lava Surface](#lava-surface) renderers.

| Property | Description |
| :--- | :--- |
| Debug Mode | Different fluid debugging modes that can be used in the editor. |
| [Surface Properties](#render-properties) | Properties that determine the mesh quality and the specific drawing mode of the fluid surface.<br/><br/>This structure holds settings that control the visual fidelity and performance of the fluid surface mesh. This includes the specific method used to render the mesh, such as standard MeshRenderer, procedural drawing, GPULOD, or a specialized HDRP mode. |
| Fluid Material | The material to be used to render the fluid surface.<br/><br/>This material is internally instantiated at runtime. The component copies the properties from the original material to the new instance, and then overrides or injects any necessary rendering requirements (e.g., shader keywords or properties) for the fluid simulation effects to function correctly. |
| [Simulation](../fluid_simulation_components#fluid-simulation) | The [Fluid Simulation](../fluid_simulation_components#fluid-simulation) component that this renderer will draw.<br/><br/>This is a mandatory dependency. The FluidRenderer will automatically adopt the world-space dimensions and position of the assigned Fluid Simulation, ensuring the rendered fluid surface matches the simulated area exactly. |
| [Flow Mapping](#fluid-flow-mapping) | The [Fluid Flow Mapping](#fluid-flow-mapping) component that this [Fluid Renderer](#fluid-renderer) uses to visualize fluid currents and wakes.<br/><br/>This component provides the necessary data to the fluid shader, which can be either a dedicated flow map texture (for dynamic UV-offsetting) or material parameters derived directly from the simulation's velocity texture. This allows the fluid surface to depict accurate movement and flow. |

<a name="i-surface-renderer"></a>
### Surface Renderer

[Surface Renderer](#i-surface-renderer) defines a interface for rendering techniques aimed at height field surfaces. Implementing classes should provide specific algorithms and methods to visualize height maps and related surface data in different graphical contexts, such as terrain or fluid fields. This interface is designed to promote extensibility, allowing developers to introduce new rendering methods as needed while adhering to a standard approach for rendering surfaces. Currently there are three classes that extend this interface.  
-  **`MeshRenderer`**  The implementation using standard [Mesh Renderer Surface](https://docs.unity3d.com/ScriptReference/MeshRenderer.html) components.  
-  **`Mesh`**  A simpler implementation using **Mesh Surface**.  
-  **`GPULOD`**  An implementation using a GPU-accelerated LOD system: **GPULOD Surface**.

All classes implementing this interface must provide functionality to clean up resources by overriding the dipose method, ensuring that any graphics resources are properly disposed of.

<a name="render-properties"></a>
### Render Properties

Properties to be used to configure components that use [Surface Renderer](#i-surface-renderer). These properties determine the mesh quality and rendering mode of the surface.

| Property | Description |
| :--- | :--- |
| Render Mode | The method used for generating and rendering the fluid surface geometry.<br/><br/>-  **`MeshRenderer`**  Uses standard GameObjects with [Mesh Renderer](https://docs.unity3d.com/ScriptReference/MeshRenderer.html) components. Best for simple setups where standard object culling is sufficient.  <br/>-  **`DrawMesh`**  Uses [Render Mesh](#render-mesh) to avoid GameObject overhead. Supports GPU Instancing.  <br/>-  **`GPULOD`**  Draws the surface using a GPU-accelerated LOD system. Best for large-scale oceans or lakes.  <br/>-  **`HDRPWaterSurface`**  Bridges the simulation data to a Unity [HDRP Water Surface](#hdrp-water-surface) component (Requires HDRP). |
| Dimension | The total world-space size (X and Z) of the rendered surface. |
| Mesh Resolution | The vertex resolution of the surface's base grid mesh.<br/><br/>For the most accurate visualization, it is recommended to match this value to the source heightmap resolution. |
| Mesh Blocks | The number of subdivisions (blocks) to split the rendering mesh into along the X and Z axes.<br/><br/>Subdividing the mesh improves GPU performance by allowing the camera to cull blocks that are outside the view frustum. |
| Lod Resolution | The vertex resolution of individual LOD patches when using **GPULOD**. |
| Traverse Iterations | The number of iterations the Quadtree traversal algorithm performs per frame when using **GPULOD**.<br/><br/>Higher values resolve the surface quality faster during camera movement but may reduce performance. |
| Lod Min Max | The range of allowable LOD levels, where X is the minimum level and Y is the maximum level. |
| [Hdrp Water Surface](#hdrp-water-surface-properties) | Configuration settings for bridging this simulation's data to an external [HDRP Water Surface](#hdrp-water-surface). |

<a name="hdrp-water-surface-properties"></a>
### HDRP Water Surface Properties

Contains settings used to bridge the fluid simulation data to the Unity HDRP Water System.

| Property | Description |
| :--- | :--- |
| Target Water Surface | The target HDRP Water System component the simulation is to be applied. (Requires HDRP package). |
| Amplitude | Controls the maximum amplitude of the Fluid Simulation used to encode/decode the height to/from 0-1 range |
| Large Current | Controls the weight that the Fluid Simulation's velocity should be applied to the Large Current waves of the HDRP Water System. |
| Ripples | Controls the weight that the Fluid Simulation's velocity should be applied to the Rupples of the HDRP Water System. |

___

<a name="water-rendering"></a>
### Water Rendering

<a name="water-surface"></a>
#### Water Surface

![Water Surface](../../assets/images/watersurface.png)

[Water Surface](#water-surface) is an extension of the [Fluid Renderer](#fluid-renderer) component that specifically deals with rendering water-related elements of the fluid simulation, such as [Foam Layer](../fluid_simulation_components#foam-layer). It accomplishes this by assigning the currently active rendering layers to its assigned material.

| Property | Description |
| :--- | :--- |
| [Foam Layer](../fluid_simulation_components#foam-layer) | A FoamLayer component that provides the dynamically generated foam mask texture for water rendering effects.<br/><br/>The component's primary role is to update and supply the dynamic foam mask texture, ensuring foam is applied accurately to the water material. It also handles necessary adjustments to the mask's texture coordinates (UVs) to maintain alignment across different rendering setups. |

<div style="page-break-after: always;"></div>

<a name="water-shader"></a>
#### Water Shader

The *FluidFrenzy/Water* shader is applied to the material used by the Water Surface component. It provides a comprehensive set of material properties for creating visually appealing water.

**Compatibility:**
This shader is compatible with both the Universal Render Pipeline (URP) and the Built-in Render Pipeline (BiRP).

Note: The High Definition Render Pipeline (HDRP) requires a separate, dedicated shader: *FluidFrenzy/HDRP/Water*.

##### Lighting

Properties controlling the illumination and shading effects.

![Water Shader](../../assets/images/watershader_slice_0_0.png)

| Property | Description |
| :--- | :--- |
| Specular Intensity | Scales the brightness of specular highlights from the main directional light. |
| Shadows | Enables or disables whether the water surface receives shadows. |

##### Reflection

Properties controlling the water surface's reflection of the environment.

![Water Shader](../../assets/images/watershader_slice_1_0.png)

| Property | Description |
| :--- | :--- |
| Planar Reflection | Enables or disables the use of planar reflections instead of only reflection probes. |
| Reflectivity Offset | Offsets the base reflectiveness of the water surface.<br/>Use this to ensure the water is reflective even at sharp viewing angles. |
| Distortion | Scales the distortion applied to planar reflections. |

##### Absorption

Properties controlling depth-based color, transparency, and refraction effects.

![Water Shader](../../assets/images/watershader_slice_2_0.png)

| Property | Description |
| :--- | :--- |
| Color | RGB sets the color of the water at maximum depth. Alpha (A) is the base transparency of the water.<br/>If 'Refraction Mode' is 'Screenspace Absorb', RGB is a color multiplier where White (1.0) is fully transparent.<br/>For 'Alpha' or 'Screenspace Tint', RGB is the final color tint the water reaches at maximum depth/opacity. |
| Depth Transparency | Scales the rate at which the water's color changes and transparency fades based on depth. Lower values make the water more transparent across its depth. |
| Refraction Mode | Selects the method for rendering water transparency and refraction:<br/><br/>• Alpha: Simple alpha blending transparency.<br/>• Opaque: Water is rendered as a solid, non-transparent surface.<br/>• Screenspace Tint: Uses screen-space refraction (GrabPass). Color interpolates from clear to the set color based on depth. Use for a single water color tint.<br/>• Screenspace Absorb: Uses screen-space refraction (GrabPass). Scene color is multiplied by water color, allowing for a color gradient (e.g., clear to turquoise to blue). |
| Distortion | Scales the amount of distortion applied to the screenspace refraction effect ('Screenspace Tint' or 'Screenspace Absorb' modes). |

##### Subsurface Scattering

Properties controlling the diffusion of light and subsurface scattering effect beneath the water surface.

![Water Shader](../../assets/images/watershader_slice_3_0.png)

| Property | Description |
| :--- | :--- |
| Color | The color the water will transition to when subsurface scattering occurs. |
| Intensity | Scales the base intensity of the subsurface scattering effect. |
| Ambient | Scales the base contribution, ensuring some subsurface scattering is visible regardless of other parameters. |
| Light Contribution | Scales the contribution of subsurface scattering when the water surface faces away from the main light. |
| View Contribution | Scales the contribution of subsurface scattering when the water surface faces toward the observer/camera. |
| Foam Contribution | Scales the subsurface scattering contribution in areas covered by foam. |

##### Waves

Properties for adding detail to the water surface using normal mapping and procedural vertex displacement.

![Water Shader](../../assets/images/watershader_slice_4_0.png)

| Property | Description |
| :--- | :--- |
| Normal Map | Texture used to add fine detail to the water's normals for lighting and PBR shading. |
| Vertex Displacement | Enables small-scale, procedural vertex displacement for finer wave details, which is based on the fluid simulation's velocity field. |
| Tiling | Scales the overall density/tiling of the procedural displacement waves. |
| Wave Amplitude | Scales the maximum height (amplitude) of the displacement waves. |
| Phase Speed | Scales the phase speed, which controls how fast the waves move up and down. |
| Wave Speed | Scales the horizontal movement speed of the displacement waves. |
| Wave Length | Scales the distance between the crests (wavelength) of the displacement waves. |
| Wave Steepness | Scales the sharpness or smoothness (steepness) of the displacement waves. |

##### Foam

Properties controlling the appearance and masking of the foam effect.

![Water Shader](../../assets/images/watershader_slice_5_0.png)

| Property | Description |
| :--- | :--- |
| Foam Color | Sets the Foam Color (RGB) and acts as a multiplier/mask (A) for the Foam Map's transparency. |
| Foam Map | Texture used for the foam's diffuse color (RGB) and its base mask/transparency (A). |
| Foam Normal Map | Normal map texture used to add PBR lighting detail to the foam. |
| Foam Visibility Range | Sets the minimum and maximum threshold values for when the foam becomes visible and reaches its maximum strength. Foam visibility is interpolated between these values using a smoothstep function. |
| Screenspace Particles | Enables the use of the screenspace particles (from the FluidParticles component) as an additional mask to generate foam. |
| Foam Mode | Selects the blending method for the foam:<br/><br/>• Albedo: Soft foam using the Foam Map for color and mask.<br/>• Clip: Hard-edged foam using the Foam Map's red channel as a clip value for sharp borders.<br/>• Mask: Uses the Foam Layer Mask's value to select one of the Foam Map's RGB channels as an extra mask for blending the foam color, allowing for varied intensity: 0-0.334 uses Blue, 0.334-0.667 uses Green, and 0.667-1 uses Red. |

##### Rendering

General rendering, depth-handling, and simulation sampling properties.

![Water Shader](../../assets/images/watershader_slice_6_0.png)

| Property | Description |
| :--- | :--- |
| Layer | Selects which layer (e.g., Water or Lava, etc.) from the Fluid Simulation field to sample for effects. |
| Fade Height | The world height at which the water will be fully faded out.<br/>Used to soften edges or blend with geometry above a certain height. |
| Linear Clip Offset | A linear offset applied to the clip-space Z depth<br/>to help prevent visual clipping (Z-fighting) with close terrain or surfaces. |
| Exponential Clip Offset | An exponential/depth-based offset applied to the clip-space Z depth<br/>to help prevent visual clipping (Z-fighting) with distant terrain or surfaces. |


<a name="water-planar-reflections"></a>
#### Planar Reflections

[Planar Reflection](#planar-reflection) is a component that generates **real-time planar reflections** for the water surface to enhance rendering quality.

This is achieved by rendering the scene again from a mirrored perspective flipped around the water plane and capturing the result to a texture. This reflection texture is then applied to the water material.  

 The script reads the height of the fluid simulation to set the reflection plane as accurately as possible. It includes built-in smoothing (controlled by [Smooth Position](#m_smooth-position)) to prevent quick, jittering changes caused by small, rapid waves on the fluid surface.  

 **Note:** To see the results of the reflection, the water material (e.g., `FluidRenderer.fluidMaterial`) must have planar reflections enabled in its shader.

![planar_reflections](../../assets/images/planar_reflections.png)

The following settings can be configured to setup the Planar reflections:

| Property | Description |
| :--- | :--- |
| Reflection Texture Size | Defines the resolution/size of the generated reflection texture. |
| Renderer ID | SRP Renderer to use for the planar reflection pass. Use this to select a cheaper render pass for the reflection camera. |
| Culling Mask | Which layers the planar reflection camera renders. |
| Clear Flags | What to display in empty areas of the planar reflection's view (e.g., Skybox, Solid Color). |
| Resolution | The quality/resolution of the generated planar reflection texture. |
| Clip Plane | A vertical offset to apply to the reflection plane. This can be used to prevent clipping artifacts with the water surface. |
| Height Sample Transform | Overrides the object whose position is used for sampling the water height, which defines the plane of reflection. If null, the component's GameObject position is used. |
| Smooth Position | Smoothes the reflection plane's height and position over multiple frames to prevent jittering caused by rapid fluid simulation updates. |

___
<div style="page-break-after: always;"></div>

<a name="lava"></a>
### Lava

<a name="lava-surface"></a>
#### Lava Surface
[Lava Surface](#lava-surface) is an extension of the [Fluid Renderer](#fluid-renderer) component that specifically deals with rendering lava-related elements of the fluid simulation.

This component adds specific lava rendering features, such as heat and emissive color gradients, by generating and applying a custom **Heat Look-Up Texture (LUT)**.  

 The LUT is procedurally generated from the **Heat** gradient field and is assigned to the [Fluid Material](#fluid-material). This allows the lava's emissive color and heat visual effect to be determined dynamically by factors like the lava's velocity or age.

![Lava Surface](../../assets/images/lavasurface.png)

| Property | Description |
| :--- | :--- |
| Generate Heat Lut | If enabled, the **Heat** gradient will be used to procedurally generate a **Heat LUT** that overrides the existing LUT on the [Fluid Material](#fluid-material). |
| Heat | The [Gradient](#gradient) used to define the heat/color transition for the lava. The color samples are mapped from Cold Lava (Left side of the gradient) to Hot Lava (Right side of the gradient). |


<a name="lava-shader"></a>
#### Lava Shader

The *FluidFrenzy/Lava* shader is applied to the material used by the Lava Surface component. It creates realistic, flowing lava visuals where the 'heat' and resulting glow are dynamically driven by the **length of the fluid's velocity vector** in the simulation.

The shader uses textures for the base 'cold' lava surface (Albedo, Smoothness, Normal Map) and employs a specialized **Heat Look-Up Table (LUT)** alongside an **Emission Map** to control the vibrant colors and intensity of the glowing, 'hot' lava. A separate **Noise** texture is used to break up tiling patterns.

**Compatibility:**
The *FluidFrenzy/Lava* shader is for URP and BiRP. The High Definition Render Pipeline (HDRP) requires a separate, dedicated shader: *FluidFrenzy/HDRP/Lava*.


![Lava Shader](../../assets/images/lavashader.png)

##### Lighting

Properties controlling the illumination and shading effects.

| Property | Description |
| :--- | :--- |
| Light Intensity | Scales the influence of the main directional light on the lava surface (e.g., specular highlights). |
| Shadows | Enables or disables if the lava surface receives shadows from other scene objects. |

##### Heat & Emission

Properties controlling the lava's color and emission, driven by the fluid's 'heat' (usually fluid velocity/movement).

| Property | Description |
| :--- | :--- |
| Heat LUT | Gradient Lookup Texture (LUT) used to determine the lava's color and emission based on the fluid's 'heat'. |
| Heat Scale | Scales the fluid 'heat' value when sampling the Heat LUT gradient. Lower values increase the effective range of the lookup. |
| Emission Map | Texture used for the emission color of the lava. A sample of this texture is multiplied by the fluid's 'heat'. |
| Emission | Scales the overall intensity of the emission determined by the Heat LUT and the Emission Map. |

##### Material Properties

Properties controlling the cold lava surface's visual and PBR shading characteristics.

| Property | Description |
| :--- | :--- |
| Albedo | Sets the base Albedo color and texture of the lava. This represents the appearance of cold (non-emissive) lava. |
| Smoothness Scale | Scales the PBR smoothness of the cold lava surface, affecting its specular reflections. |
| Normal Map | Normal map texture used to add detailed lighting to the cold lava surface. |
| Noise | Noise texture used to eliminate noticeable tiling and repetition from the lava textures. |

##### Rendering

General rendering, depth-handling, and simulation sampling properties.

| Property | Description |
| :--- | :--- |
| Layer | Selects which layer (e.g., Water or Lava, etc.) from the Fluid Simulation field to sample for effects. |
| Fade Height | The world height at which the lava will be fully faded out.<br/>Used to soften edges or blend with geometry above a certain height. |
| Linear Clip Offset | A linear offset applied to the clip-space Z depth<br/>to help prevent visual clipping (Z-fighting) with close terrain or surfaces. |
| Exponential Clip Offset | An exponential/depth-based offset applied to the clip-space Z depth<br/>to help prevent visual clipping (Z-fighting) with distant terrain or surfaces. |

___

<a name="particle-shaders"></a>
### Particles Shaders
Fluid Frenzy uses custom shaders to render its completely GPU-accelerated particle system. Two shaders are available: *ProceduralParticle* (Lit) and *ProceduralParticleUnlit*. Both render particles as billboards.

- ProceduralParticle (Lit): Includes PBR lighting with support for Normal Maps, Metallic, and Smoothness.
- ProceduralParticleUnlit (Unlit): Does not perform lighting, offering a lower rendering cost.

Both shaders share settings for **Blend Mode** and **Billboard Mode**. **Billboard Mode** controls particle orientation, including options for camera-facing or world-up normals to manage lighting.

**Compatibility**:
For URP and BiRP, the shaders are *FluidFrenzy/ProceduralParticle* and *FluidFrenzy/ProceduralParticleUnlit*.
The High Definition Render Pipeline (HDRP) requires its own dedicated shaders: *FluidFrenzy/HDRP/ProceduralParticle* and *FluidFrenzy/HDRP/ProceduralParticleUnlit*.

![Particle Shader](../../assets/images/particle_shader.png)

##### Properties

| Property | Description |
| :--- | :--- |
| Albedo | albedo color and transparency of the particle. |
| Color | albedo color and transparency of the particle. |
| Normal Map | can be used to add extra lighting details. |
| Alpha Threshold | Alpha below this value will be clipped. |
| Blend Mode | select which to use for the particles. |
| Source Blend | Source Blend. |
| Dest Blend | Dest Blend. |
| ZWrite | Write particle to the depth buffer. |
| Billboard Mode | Select which method to use for rendering the particle billboard.<br/><br/>• Camera: the billboard and world normal will face in the direction of the camera.<br/><br/>• Camera Normal Up: the billboard will face the camera and the normal will face in in the world space up direction.This can be useful to have more uniform lighting from every direction.<br/><br/>• Up: the billboard and normal will both face in the world space up direction.<br/><br/>• Normal: not yet implemented. |
| Metallic | The metalness of this material. |
| Smoothness | The smoothness of this material. |
| Lighting |  |
| Rendering |  |

<a name="shadow-grabber"></a>
### Shadows
Both the Water and Lava is rendered after any opaque layers to allow for refraction and to prevent sorting issues. This means that in the Built-in Render pipeline shadows are not automatically sampled due to the transparent nature of the rendering. In order to solve this the user can add he **ShadowGrabber** component to the **Main Directional Light** in the scene. This will assign the shadow buffer to global shader property so that the Water and Lava shader can read it. In order for a material to read it the Shadows property on the Material needs to be set to either *Hard* or *Soft*.

<a name="hdrp-water-system"></a>
<a name="hdrp-water-surface"></a>
### HDRP Water System
Fluid Frenzy has the ability to apply the Fluid Simulation's data to the [HDRP Water System](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@14.0/manual/WaterSystem-use.html). This allows the user to enhance their HDRP scene without sacrificing the quality HDRP provides.

To support this the user will have to enable decal support in their HDRP Quality settings:
![alt text](../../assets/images/hdrp_settings_decal.png)

The displacement and flowmapping of the Fluid Simulation is applied using the [Water Decal](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@17.1/manual/water-deform-a-water-surface.html) system, which is automatically created when setting the [Water Surface](#water-surface) to the **HDRP Water System** mode.
The Water Decal system uses signed normalized render buffers to apply the displacement, which requires a amplitude to be applied to the decal. This amplitude is the maximum height the simulation will be able to displace the water surface.

![alt text](../../assets/images/hdrp_watersurface_settings.png)

| Property | Description |
| :--- | :--- |
| Target Water Surface | The target HDRP Water System component the simulation is to be applied. (Requires HDRP package). |
| Amplitude | Controls the maximum amplitude of the Fluid Simulation used to encode/decode the height to/from 0-1 range |
| Large Current | Controls the weight that the Fluid Simulation's velocity should be applied to the Large Current waves of the HDRP Water System. |
| Ripples | Controls the weight that the Fluid Simulation's velocity should be applied to the Rupples of the HDRP Water System. |

___

<a name="terrain"></a>
