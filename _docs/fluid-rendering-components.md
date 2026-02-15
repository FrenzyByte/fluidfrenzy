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

The [Water Surface](#water-surface) is an extension of the [Fluid Renderer](#fluid-renderer) component that renders all things water like [Foam Layer](../fluid_simulation_components#foam-layer), [Underwater Effect](#underwater-effect) visuals, absorption, and scattering.
It does this by assigning the active rendering layers to its surface material and using the underwater settings.

| Property | Description |
| :--- | :--- |
| [Foam Layer](../fluid_simulation_components#foam-layer) | A FoamLayer component that provides the dynamically generated foam mask texture for water rendering effects.<br/><br/>The component's primary role is to update and supply the dynamic foam mask texture, ensuring foam is applied<br/>accurately to the water material. It also handles necessary adjustments to the mask's texture coordinates (UVs)<br/>to maintain alignment across different rendering setups. |
| Under Water Enabled | Controls whether the [Underwater Effect](#underwater-effect) is currently enabled. |
| [Under Water Settings](#underwater-settings) | Settings for all configurable visual parameters of the [Underwater Effect](#underwater-effect).<br/>This class defines how light interacts with the water volume, including absorption rates, scattering colors, and the appearance of the surface meniscus. |
| Caustics Enabled | Controls whether the [Caustics Effect](#caustics-effect) is currently enabled. |
| [Caustics Settings](#caustics-settings) | Settings for the [Caustics Effect](#caustics-effect), which renders animated light patterns projected onto the scene geometry underwater. |
| Reflections Enabled | Controls whether real-time planar reflections are generated for this water surface. |
| [Reflection Settings](#settings) | Settings for the [Surface Reflections](#surface-reflections) module (Planar Reflections). |

<div style="page-break-after: always;"></div>

<a name="water-shader"></a>
#### Water Shader

The `FluidFrenzy/Water` shader is applied to the material used by the Water Surface component. It provides a comprehensive set of material properties for creating visually appealing water.

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


<a name="underwater-effect"></a>
#### Underwater Effect

The [Underwater Effect](#underwater-effect) module renders the visuals you see when the camera goes underwater. It is supported in all render pipelines.

It uses the same simulation math as the water surface to ensure the underwater volume matches the waves perfectly. 
However it has its own independent visual settings, allowing you to style the underwater atmosphere separately from the surface itself.

This distinction is useful for gameplay as you can make the underwater view clearer or brighter than the surface to help players see further. 
The effect handles features like light absorption, fog scattering, and directional lighting to create the underwater atmosphere.

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_intro.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

<a name="underwater-settings"></a>
#### Underwater Settings

Settings for all configurable visual parameters of the [Underwater Effect](#underwater-effect).
This class defines how light interacts with the water volume, including absorption rates, scattering colors, and the appearance of the surface meniscus.

#####  Absorption

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_absorption.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Water Color | The base transmission color of the water.<br/><br/>This defines the color of the water as light passes through it. Brighter colors make the water look clear while darker colors make the water look thick and deep. This works with the alpha value and the absorption depth scale to decide how much the scene behind the water is tinted. |
| Depth Transparency | Controls the rate at which light is absorbed as it travels through the water.<br/><br/>Higher values result in darker water where light cannot penetrate as deeply. This scaling factor applies to the exponential decay of the **Water Color**. |
| Depth Limits | Clamps the calculated absorption to a specific range (Min, Max).<br/><br/>Useful for preventing the water from becoming completely black at extreme depths or ensuring a minimum amount of visibility. |

#####  Meniscus(Water Line)

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_meniscus.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Thickness | The vertical thickness of the meniscus line (the water-air boundary) on the camera lens. |
| Blur | The amount of blur applied to the meniscus line to soften the transition between underwater and above-water. |
| Darkness | Controls the intensity/darkness of the meniscus line effect. |

#####  Scattering (Fog)

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_scattering.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Scatter Color | The color of the light scattered within the water volume (subsurface scattering/fog color). |
| Scatter Ambient | The base ambient contribution to the scattering effect, independent of direct lighting. |
| Light Intensity | Scales the influence of the main directional light on the scattering effect. |
| Total Intensity | A global multiplier for the overall scattering intensity. |

<a name="caustics-effect"></a>
#### Caustics Effect

**Caustics** is an option on the [Water Surface](#water-surface) that simulates the shifting light patterns projected onto the seafloor and submerged objects.

![alt text](../../assets/images/caustics.png)

To keep performance high, the system uses a fast approximation rather than trying to calculate physically accurate light paths. It combines an animated texture sequence with procedural highlights that are tied to the surface wave curvature, ensuring the light patterns always match the motion of the water above.

The effect works directly with the [Fluid Simulation](../fluid_simulation_components#fluid-simulation), meaning it uses the same flow mapping as the surface itself. If the water is flowing or swirling, the caustics will follow that same movement. You can also enable triplanar projection to prevent the patterns from stretching or smearing on vertical surfaces like underwater cliffs or steep walls.

It also accounts for surface conditions for example, **Foam Masking** can be used to soften or dim the light patterns in areas where thick foam would naturally scatter the light. To keep transitions smooth, the effect uses depth fading to blend the patterns in and out based on how far they are from the surface, preventing them from looking too sharp at the shoreline or in very deep water.

<a name="caustics-settings"></a>
#### Caustics Settings

Settings for all configurable visual parameters of the [Caustics Effect](#caustics-effect).
This class defines animated light patterns projected underwater, wave-driven highlights, and global visibility attenuation.

##### Texture Projection
You can use these settings to customize the look of the animated texture patterns, including how fast they move, how they warp with the waves, and whether they use triplanar mapping to stay consistent on vertical walls.

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/caustics_texture_projection.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Animation FPS | The playback speed of the animated caustics texture sequence.<br/><br/>Defines how many frames per second the texture advances. Higher values result in faster, smoother motion. |
| Tiling | Controls the scale of the projected caustics pattern.<br/><br/>Higher values increase the tiling frequency, making the pattern appear smaller and more dense across the environment. |
| Triplanar Projection | Enables triplanar projection to prevent texture stretching on vertical surfaces.<br/><br/>Projects the texture from three orthogonal axes (X, Y, Z) instead of a single top-down projection. <br/>Essential for maintaining pattern consistency on cliffs, walls, and steep underwater terrain. |
| Wave UV Distortion | The strength of the UV distortion applied to the caustics based on surface wave normals.<br/><br/>Simulates refractive warping by shifting the texture coordinates relative to the waves above. |
| Texture Intensity | The brightness multiplier for the projected caustics texture.<br/><br/>An independent scalar specifically for the animated texture component of the effect. |
| Channel Mask | Defines which texture color channels contribute to the final caustics pattern.<br/><br/>Useful for isolating specific channels in packed textures. |
| Chromatic Aberration | The strength of the color splitting effect at the edges of the caustics.<br/><br/>Simulates light dispersion (prismatic effect), creating rainbow-like fringing around high-contrast areas of the pattern. |

##### Wave Highlights
These properties control procedural glints calculated directly from the surface waves, allowing you to adjust the intensity and sharpness of the light streaks hitting the seafloor.

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/caustics_wave_highlights.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Wave Intensity | The brightness of the procedural glints generated by surface wave curvature.<br/><br/>Unlike the texture projection, these highlights are calculated analytically from wave refraction to provide a direct link between the surface and the seafloor. |
| Wave Sharpness | Controls the focus and size of the procedural wave highlights.<br/><br/>Higher values result in sharper, thinner glints (lensing effect), while lower values create broader, softer highlights. |

##### Global Settings
This section handles the overall strength and blending of the effect, including how it reacts to shadows and foam, and how it fades out as the water depth increases.

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/caustics_global.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Global Intensity | A multiplier for all caustic lighting contributions.<br/><br/>Scales both the texture projection and the procedural wave highlights simultaneously. |
| Darkness | Controls how much the sea floor is darkened in the areas between light patterns.<br/><br/>Increasing this value darkens the *caustic shadows*, making the bright light patterns appear more high-contrast and prominent. |
| Shadow Intensity | Controls the visibility of caustics within areas shadowed by external light sources.<br/><br/>A value of 0 makes caustics completely invisible in shadow, while a value of 1 allows them to remain fully visible. |
| Surface Fade-In | Defines the depth range near the surface where the caustics begin to appear.<br/><br/>The X value represents the depth where the effect starts, and the Y value is where it reaches full intensity. This prevents visual "popping" at the water line. |
| Depth Fade-Out | Defines the depth range where the caustics gradually disappear as light is absorbed.<br/><br/>The X value is the depth where fading begins, and the Y value is the depth where caustics are completely extinguished. |
| Foam Masking | Controls how much surface foam occludes the caustics on the seafloor.<br/><br/>Simulates the diffusive nature of bubbles. Thick foam scatters light, preventing sharp caustics from forming and casting a soft shadow on the environment below. |


<a name="surface-reflections"></a>
#### Surface Reflections

**Surface Reflections** are a set of settings on the [Water Surface](#water-surface) component that generate **real-time reflections** to enhance the rendering quality of the water.

This is achieved by rendering the scene again from a mirrored perspective flipped around the water plane and capturing the result to a texture. This reflection texture is then applied to the water material.  

The component reads the height of the fluid simulation to set the reflection plane as accurately as possible. It includes built-in smoothing (controlled by [Smooth Position](#m_smooth-position)) to prevent quick, jittering changes caused by small, rapid waves on the fluid surface.  

**Note:** To see the results of the reflection, the water material (e.g., `FluidRenderer.fluidMaterial`) must have surface reflections enabled in its shader.

**Note:** HDRP does not use Surface Reflections in the water shader, it uses the reflections directly rendered by the pipeline.

![planar_reflections](../../assets/images/planar_reflections.png)

The following settings can be configured to setup the Planar reflections:

| Property | Description |
| :--- | :--- |
| Resolution | The quality/resolution of the generated planar reflection texture. |
| Culling Mask | Which layers the planar reflection camera renders. |
| Clear Flags | What to display in empty areas of the planar reflection's view (e.g., Skybox, Solid Color). |
| Clip Plane | A vertical offset to apply to the reflection plane. This can be used to prevent clipping artifacts with the water surface. |
| Smooth Position | Smoothes the reflection plane's height and position over multiple frames to prevent jittering caused by rapid fluid simulation updates. |
| Renderer ID | SRP Renderer to use for the planar reflection pass. Use this to select a cheaper render pass for the reflection camera. |
| Shadow Quality | Controls shadow rendering in the reflection (BiRP Only). |


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
