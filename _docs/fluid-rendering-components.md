---
title: Fluid Rendering Components
permalink: /docs/fluid_rendering_components/
---


<a name="fluid-renderer"></a>
### Fluid Renderer

The [Fluid Renderer](#fluid-renderer) component is responsible for rendering the [Fluid Simulation](../fluid_simulation_components#fluid-simulation). This component is in charge of creating and rendering the necessary meshes and materials needed for displaying the assigned [Fluid Simulation](../fluid_simulation_components#fluid-simulation). Users can customize the [Fluid Renderer](#fluid-renderer) component to create their own rendering effects, similar to [Water Surface](#water-surface) and [Lava Surface](#lava-surface) renderers.

| Property | Description |
| :--- | :--- |
| Debug Mode | Different fluid debugging modes that can be used in the editor. |
| [Surface Properties](#render-properties) | Properties that determine the mesh quality and the specific drawing mode of the fluid surface.<br/><br/>This structure holds settings that control the visual fidelity and performance of the fluid surface mesh. <br/>This includes the specific method used to render the mesh, such as standard MeshRenderer, procedural drawing, GPULOD, or a specialized HDRP mode. |
| Fluid Material | The material to be used to render the fluid surface.<br/><br/>This material is internally instantiated at runtime. The component copies the properties from the original material to the new instance, <br/>and then overrides or injects any necessary rendering requirements (e.g., shader keywords or properties) for the fluid simulation effects <br/>to function correctly. |
| [Simulation](../fluid_simulation_components#fluid-simulation) | The [Fluid Simulation](../fluid_simulation_components#fluid-simulation) component that this renderer will draw.<br/><br/>This is a mandatory dependency. The FluidRenderer will automatically adopt the world-space dimensions and position of the assigned Fluid Simulation,<br/>ensuring the rendered fluid surface matches the simulated area exactly. |
| [Flow Mapping](#fluid-flow-mapping) | The [Fluid Flow Mapping](#fluid-flow-mapping) component that this [Fluid Renderer](#fluid-renderer) uses to visualize fluid currents and wakes.<br/><br/>This component provides the necessary data to the fluid shader, which can be either a dedicated flow map texture (for dynamic UV-offsetting) <br/>or material parameters derived directly from the simulation's velocity texture. This allows the fluid surface to depict accurate movement and flow. |
| Render Skirts | Renders downward skirts at the edges of the fluid surface. |

<a name="fluid-world-renderer"></a>
### Fluid World Renderer

[Fluid World Renderer](#fluid-world-renderer) draws multiple [Fluid Simulation](../fluid_simulation_components#fluid-simulation) tiles as one continuous surface. Use it for open oceans, large lakes, and any scene where simulation is split across several domains but should look and behave like a single body of water (or other fluid type).

The component always renders with `GPULOD`. Each frame it gathers matching simulation tiles in the scene, composites their height, normal, terrain, foam, and flow data, and draws one world-scale surface from that combined result. You configure the footprint, material, channels, and optional ocean/detail-wave layers in the Inspector on this one object.

For water-specific rendering (underwater, caustics, reflections, foam on the world surface), use [Water World Renderer](#water-world-renderer) instead. It extends this component with the same features as [Water Surface](#water-surface) on a per-tile [Fluid Renderer](#fluid-renderer).

#### Fluid Renderer vs Fluid World Renderer

Each [Fluid Simulation](../fluid_simulation_components#fluid-simulation) can still have its own [Fluid Renderer](#fluid-renderer) or [Water Surface](#water-surface) for local effects, debugging, or single-tile scenes. In a tiled open-world setup you typically rely on the world renderer for the visible surface and disable or omit per-tile renderers to avoid drawing the same water twice.

| Use [Fluid Renderer](#fluid-renderer) | Use [Fluid World Renderer](#fluid-world-renderer) |
| :--- | :--- |
| One simulation domain | Many simulation tiles in one view |
| Any [Render Mode](#render-properties) (`MeshRenderer`, `DrawMesh`, `GPULOD`, HDRP Water) | `GPULOD` only |
| Per-tile underwater, caustics, reflections via [Water Surface](#water-surface) | Multi-tile water features via [Water World Renderer](#water-world-renderer) |

#### Setting up a tiled world

A typical multi-tile workflow looks like this:

1. Place one [Fluid Simulation](../fluid_simulation_components#fluid-simulation) per region. Align tiles in the scene so their domains meet edge to edge.
2. On shared edges, set [Side Border Settings](../fluid_simulation_components#fluid-side-border) to **Neighbour** and use the same **Group ID** so simulations stay connected. **Grid Pos** helps neighbour discovery; compositing itself follows each tile's position and size in the scene.
3. Add a **Fluid World Renderer** (or **Water World Renderer**) to the scene. Set [Surface Properties](#render-properties) **Dimension** to the XZ area you want the world surface to cover.
4. Match [Fluid Channels](../setup#fluid-channels) on the renderer and on each simulation you want included. See [Fluid Channels](../setup#fluid-channels) in Setup for naming and masking.
5. Enable ocean FFT in [Ocean FFT Settings](#fft-generator-settings) for large open-water swell. On [Flow Fluid Simulation](../fluid_simulation_components#flow-fluid-simulation) tiles, configure [Ocean FFT Coupling](../fluid_simulation_components#flow-fluid-simulation) so local shallow-water flow follows the ocean motion near coastlines.
6. Optionally enable detail waves in [Detail Wave Settings](#detail-wave-settings) for small ripples on top of the composited surface. These are visual only and do not affect simulation or [Fluid RigidBody](../fluid_simulation_components#fluid-rigidbody) physics.

Up to 32 simulation tiles can be composited at once. [Fluid RigidBody](../fluid_simulation_components#fluid-rigidbody) buoyancy works across the combined surface when a world renderer is present; single-tile setups still use [Read Back Height](#read-back-height) on the simulation instead.

#### Which simulations are included

The renderer does not reference simulation objects directly. Any [Fluid Simulation](../fluid_simulation_components#fluid-simulation) in the scene whose [Fluid Channels](../setup#fluid-channels) overlap the renderer mask is drawn:

`(renderer mask & simulation.fluidChannels) != 0`

Use `~0` on both sides to include every channel. Use separate channel masks and separate world renderers when you want independent surfaces (for example one renderer for ocean water and another for lava).

#### General

![Fluid World Renderer General](../../assets/images/worldrenderer_general.png)

| Property | Description |
| :--- | :--- |
| [Fluid Channels](../setup#fluid-channels) | Bitmask of simulation channels included in the world atlas.<br/><br/>A [Fluid Simulation](../fluid_simulation_components#fluid-simulation) is packed when `(renderer mask & simulation.fluidChannels) != 0`.<br/>Use ~0 to include all channels, or 0 to pack nothing. |
| Fluid Material | The material to be used to render the fluid surface.<br/><br/>This material is internally instantiated at runtime. The component copies the properties from the original material to the new instance,<br/>and then overrides or injects any necessary rendering requirements (e.g., shader keywords or world-atlas textures) for the fluid simulation effects<br/>to function correctly. |

#### Mesh Rendering

![Fluid World Renderer Mesh Rendering](../../assets/images/worldrenderer_rendering.png)

| Property | Description |
| :--- | :--- |
| [Surface Properties](#render-properties) | Properties that determine the mesh quality and the specific drawing mode of the fluid surface.<br/><br/>This structure holds settings that control the visual fidelity and performance of the fluid surface mesh.<br/>World rendering uses `GPULOD`; set [Render Properties](#render-properties) to the XZ footprint used for GPULOD and shader sampling (see Mesh Rendering in the Inspector). |
| Tile Id Grid Resolution | Resolution of the world-space tile index texture (XZ) used by GPULOD and shaders to map positions to atlas tiles.<br/><br/>Higher values improve lookup precision for large worlds at the cost of memory and sampling cost. |
| Debug Visualization | Different fluid debugging modes that can be used in the editor.<br/><br/>Play Mode only. Uses shader `FluidFrenzy/Debug/SimulationData` (same family as [Fluid Renderer](#fluid-renderer)).<br/>Height, normals, velocity (from the height/velocity atlas), UV, and LOD modes are supported for world-atlas rendering. |

<a name="water-world-renderer"></a>
### Water World Renderer

Extension of [Fluid World Renderer](#fluid-world-renderer) for multi-tile water: foam, underwater, caustics, and planar reflections, mirroring [Water Surface](#water-surface) on [Fluid Renderer](#fluid-renderer). Configure underwater, caustics, and surface reflections in the [Water Rendering](#water-rendering) sections below.

<a name="fft-generator"></a>
<a name="fft-generator-settings"></a>
#### Ocean FFT Settings

Settings for the cascaded ocean FFT on [Fluid World Renderer](#fluid-world-renderer). These control the JONSWAP spectrum, cascade layers, and distance fades used for large-scale open-water displacement. To apply that motion on the shallow-water solver, configure [Ocean FFT Coupling](../fluid_simulation_components#flow-fluid-simulation) on each [Flow Fluid Simulation](../fluid_simulation_components#flow-fluid-simulation) tile.

![Fluid World Renderer Ocean FFT](../../assets/images/worldrenderer_fft.png)

| Property | Description |
| :--- | :--- |
| Ocean Fft Enabled | Enables cascaded ocean FFT displacement (JONSWAP spectrum) on the world surface.<br/><br/>When enabled, the renderer selects global cascade-count shader keywords and binds FFT data via shader globals. |
| Water Preset | A starting profile for the ocean waves.<br/><br/>Pick a preset for quick results, or choose Custom and tune the fields yourself. Changing spectrum or cascade values switches back to Custom. |
| Resolution | Internal resolution of each wave layer.<br/><br/>Higher values look sharper but use more GPU memory and time. |
| Cascade Count | How many wave size layers are active.<br/><br/>C1 is the largest, longest waves. More layers add detail but cost more. Inactive layers are ignored at runtime. |
| Wind Speed | Wind speed in meters per second.<br/><br/>Stronger wind builds taller, faster-moving waves. |
| Scales | World size in meters for each wave layer (C1-C4).<br/><br/>C1 covers the largest area (open-ocean swell). Smaller values on later cascades add nearby chop and ripples. |
| Choppiness | Horizontal curling of each wave layer.<br/><br/>Higher values make crests sharper and more displaced. Values are capped to avoid broken-looking folds. |
| Intensities | Height of each wave layer.<br/><br/>Scales how tall each cascade moves the surface up and down. |
| Speeds | Animation speed of each wave layer.<br/><br/>Multiplier on how fast each cascade moves over time. |
| Wind Direction | Wind direction in degrees.<br/><br/>Controls which way the generated waves prefer to travel. |
| Fetch | How far the wind has blown over open water, in meters.<br/><br/>Larger fetch builds longer, more developed swell. Use smaller values for bays, lakes, and rivers. |
| Spread Blend | Blend between wind chop and organized swell direction.<br/><br/>Lower values spread waves in more directions. Higher values align waves with the wind. |
| Swell | Amount of long, rolling swell.<br/><br/>Adds slower, larger motion on top of wind-driven waves. |
| Peak Enhancement | How peaked the largest waves are.<br/><br/>Higher values sharpen wave crests in the spectrum. |
| Short Waves Fade | Softening of the smallest ripples.<br/><br/>Reduces high-frequency shimmer. Raise slightly if the surface looks too noisy. |
| Depth | Average water depth in meters.<br/><br/>Shallow water shortens wavelengths and changes wave shape. Use a low value near shores and rivers. |
| Generation Threshold | How much wave folding is needed before whitecaps appear.<br/><br/>Lower values show foam on milder crests. Higher values require stronger breaking. |
| Generation Amount | Strength of fresh foam at breaking crests.<br/><br/>Higher values inject foam faster where waves are actively breaking. |
| Dissipation Speed | How quickly existing foam fades away.<br/><br/>Higher values remove foam faster once waves stop breaking. |
| Falloff Speed | How much leftover foam blends into neighboring texels.<br/><br/>Higher values keep tighter streaks along crests. Lower values smear foam trails wider. This controls spatial spread, not fade over time. |
| Displacement Fade | Distance range where FFT waves fade out near the camera.<br/><br/>X = start fading, Y = fully faded. Uses cascade distance units (not meters); finer layers fade closer than large swell. |
| Normal Mip Fade | Distance range where wave normals soften far from the camera.<br/><br/>X = begin softening (meters), Y = full softening (meters). Helps distant ocean look smoother. |
| Normal Mip Max | Maximum softening applied to far-away wave normals.<br/><br/>Works with Normal Mip Fade to reduce sparkly detail in the distance. |
| Vertical Bias | Vertical offset of the FFT ocean surface in world space.<br/><br/>Raises or lowers the rendered ocean without moving the fluid simulation mesh. Also used when deciding if thin sim water should be hidden in favor of the ocean look. |

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
| Render Mode | The method used for generating and rendering the fluid surface geometry.<br/><br/>- **`MeshRenderer`** <br/> Uses standard GameObjects with `Mesh Renderer` components. Best for simple setups where standard object culling is sufficient.<br/> <br/>- **`DrawMesh`** <br/> Uses `Render Mesh` to avoid GameObject overhead. Supports GPU Instancing.<br/> <br/>- **`GPULOD`** <br/> Draws the surface using a GPU-accelerated LOD system. Best for large-scale oceans or lakes.<br/> <br/>- **`HDRPWaterSurface`** <br/> Bridges the simulation data to a Unity `HDRP Water Surface` component (Requires HDRP). |
| Dimension | The total world-space size (X and Z) of the rendered surface. |
| Mesh Resolution | The vertex resolution of the surface's base grid mesh.<br/><br/>For the most accurate visualization, it is recommended to match this value to the source heightmap resolution. |
| Mesh Blocks | The number of subdivisions (blocks) to split the rendering mesh into along the X and Z axes.<br/><br/>Subdividing the mesh improves GPU performance by allowing the camera to cull blocks that are outside the view frustum. |
| Lod Resolution | The vertex resolution of individual LOD patches when using `GPULOD`. |
| Traverse Iterations | The number of iterations the Quadtree traversal algorithm performs per frame when using `GPULOD`.<br/><br/>Higher values resolve the surface quality faster during camera movement but may reduce performance. |
| Lod Min Max | The range of allowable LOD levels, where X is the minimum level and Y is the maximum level. |
| [Hdrp Water Surface](#hdrp-water-surface-properties) | Configuration settings for bridging this simulation's data to an external `HDRP Water Surface`. |

<a name="detail-wave-effect"></a>
### Detail Wave Effect

This effect handles the small surface ripples (detail waves) for the fluid by managing GPU math for real-time waves or playing back pre-rendered textures.

![detail wave effect](../../assets/images/detail-wave-effect.png)

These ripples are purely visual and do not affect the actual fluid simulation, physics interactions, or buoyancy math. 
To save on GPU performance, you can bake these waves into static textures or flipbooks using the generator tool found at **Window > Fluid Frenzy > Detail Wave Generator**.

![detail wave generator](../../assets/images/detail-wave-generator.png)

<a name="detail-wave-settings"></a>
#### Detail Wave Settings

![Fluid World Renderer Detail Waves](../../assets/images/worldrenderer_detailwaves.png)

| Property | Description |
| :--- | :--- |
| Detail Waves Enabled | Enables procedural or baked detail waves on the world surface.<br/><br/>These ripples are purely visual and do not affect the fluid simulation, physics, or buoyancy. |
| Mode | Determines the method used to generate or display detail waves on the fluid surface.<br/><br/>- **Baked** Uses a single static texture for maximum performance but lacks motion.<br/>- **Flipbook** Cycles through a pre-rendered texture array for smooth animation at a low GPU cost.<br/>- **Dynamic** Calculates procedural wave math in real-time for infinite variety at a higher performance cost. |
| Resolution | The pixel dimensions of the generated wave texture.<br/><br/>Gerstner supports any power-of-two up to 1024 for bakes / dynamic. FFT snaps to 64-512 only. |
| Min Frequency | Defines the scale of the largest waves in the generated spectrum.<br/><br/>Low values (1-2) create large, rolling swells. <br/>High values (5+) make the primary wave shapes much smaller and busier. |
| Max Frequency | Defines the scale of the smallest ripples.<br/><br/>Low values result in a smoother surface. <br/>High values add high-frequency micro-fidget and "noise" to the water surface. |
| Amplitude | A global multiplier for the internal wave height math.<br/><br/>This scales the wave spectrum before it is packed into the texture. <br/>Use this to push waves toward their maximum normalized height. |
| Steepness | Determines the sharpness of the wave crests.<br/><br/>1.0 creates smooth, hilly waves. <br/>Higher values (up to 8.0) pinch the crests into sharp, aggressive peaks. |
| Anisotropy | Stretches frequencies to create wind-streaks.<br/><br/>1 = Circular ripples, 10 = Long streaks |
| Random Seed | The seed used to initialize the random layout of the wave pattern.<br/><br/>Change this to get a different visual layout using the same settings. |
| Animation Type | Determines if the waves bob in place or travel in direction. |
| Animation Speed | How fast the wave shapes change or travel.<br/><br/>Higher values make the water look more energetic and wind-swept. |
| Spectrum | Gerstner sum vs JONSWAP FFT (same packed height/normal texture). FFT requires a compute shader. |
| Wind Direction | The direction the waves travel (Only applies to Drifting mode). || Directional Spread | Controls the alignment of wave directions.<br/><br/>1.0 makes waves move in all directions (chaotic). <br/>0.1 forces waves into organized, parallel rows. |
| Baked Texture | The texture asset used for displacement when in Baked mode.<br/><br/>Expected format: Alpha channel for Height, RGB channels for Normals. |
| Baked Texture Array | A sequence of wave frames stored as a compressed Texture2DArray. |
| Flipbook FPS | The speed at which the flipbook cycles through frames. |
| Displacement Strength | The vertical scale of the displacement applied to the surface mesh.<br/><br/>Higher values make the waves physically taller in world space. |
| Normal Strength | The intensity of the small-scale lighting details.<br/><br/>Controls the normal map strength. <br/>High values make ripples catch more light and appear rougher. |
| Velocity Influence | X = Minimum strength at 0 velocity. Y = Maximum strength multiplier. |
| Fade Distance | Distance (Start, End) in meters where detail waves fade out to prevent shimmering and tiling artifacts. |
| Tiling | How many times the wave pattern repeats across the surface area. |
| Offset | A manual offset to scroll or shift the wave pattern. |
| Directional Spread | Controls the alignment of wave directions.<br/><br/>1.0 makes waves move in all directions (chaotic). <br/>0.1 forces waves into organized, parallel rows. |


<a name="hdrp-water-surface-properties"></a>
### HDRP Water Surface Properties

Contains settings used to bridge the fluid simulation data to the Unity HDRP Water System.

| Property | Description |
| :--- | :--- |
| Target Water Surface | The target HDRP Water System component the simulation is to be applied. (Requires HDRP package). |
| Amplitude | Controls the maximum amplitude of the Fluid Simulation used to encode/decode the height to/from 0-1 range |
| Large Current | Controls the weight that the Fluid Simulation's velocity should be applied to the Large Current waves of the HDRP Water System. |
| Ripples | Controls the weight that the Fluid Simulation's velocity should be applied to the Rupples of the HDRP Water System. |
| Mesh Resolution | The vertex resolution of the surface's base grid mesh. |
| Dimension | The total world-space size (X and Z) of the rendered surface. |
| Height Scale | The scale that will be applied to the height value in the surface's height field. |
| Max Height | The maximum height the surface will be. This is used for the culling bounds of the meshes. |
| Heightmap Mask | Specifies which channels of the heightmap to read 1 is read, 0 is ignore. <br/>The result is accumulated with the following formula: dot(heightTexel, heightmapMask) |
| Lod Min Max | The minimum and maximum LOD levels that can be selected for the surface. lodMinMax.x(min) lodMinMax.y(max) |

___

<a name="water-rendering"></a>
### Water Rendering

<a name="water-surface"></a>
#### Water Surface

![Water Surface](../../assets/images/watersurface.png)

The [Water Surface](#water-surface) is an extension of the [Fluid Renderer](#fluid-renderer) component that renders all things water like [Foam Layer](../fluid_simulation_components#foam-layer), [Underwater Effect](#underwater-effect) visuals, absorption, and scattering.
It does this by assigning the active rendering layers to its surface material and using the underwater settings.

Underwater, caustics, and surface reflections use the same settings on [Water Surface](#water-surface) and [Water World Renderer](#water-world-renderer). See [Underwater Settings](#underwater-settings), [Caustics Settings](#caustics-settings), and [Surface Reflections](#surface-reflections) below.

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

| Property | Description |
| :--- | :--- |
| Under Water Enabled | Controls whether the [Underwater Effect](#underwater-effect) is currently enabled. |

#####  Absorption

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_absorption.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Color | The base transmission color of the water (Physical mode).<br/><br/>This defines the color of the water as light passes through it. Brighter colors make the water look clear, while darker colors make the water look thick and deep. This works with the absorption depth scale to decide how much the scene behind the water is tinted. |
| Absorption Depth Scale | Controls the rate at which light is absorbed as it travels through the water.<br/><br/>Higher values result in darker water where light cannot penetrate as deeply. This scaling factor applies to the exponential decay of the absorption color. |
| Absorption Limits | Clamps the calculated absorption to a specific range (Min, Max).<br/><br/>Useful for preventing the water from becoming completely black at extreme depths or ensuring a minimum amount of visibility. |
| Color | The color of the light scattered within the water volume (subsurface scattering/fog color).<br/><br/>Defines the color of the fog when light illuminates the water. Usually a bright cyan or teal for tropical water, or a murky green/brown for swamps. |
| Ambient Intensity | The base ambient contribution to the scattering effect, independent of direct lighting.<br/><br/>Higher values cause the underwater fog to glow brightly even in shadows or when facing away from the sun. Lower values rely purely on direct sunlight for illumination. |
| Total Intensity | A global multiplier for the overall scattering intensity.<br/><br/>Higher values create a dense, opaque volumetric fog. Lower values make the scattering very subtle, preserving the clarity of the absorption color. |


#####  Meniscus(Water Line)

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_meniscus.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Meniscus Thickness | The vertical thickness of the meniscus line on the camera lens (in centimeters).<br/><br/>Simulates water clinging to the camera glass. Higher values create a thicker, more prominent droplet band at the waterline. Set to 0 to completely disable the meniscus effect. |
| Darkness | Controls the intensity/darkness of the meniscus line effect.<br/><br/>Low values give the band a subtle, colorful tint matching the water color. High values simulate a physically thick droplet that blocks incoming light, creating a dark rim. |
| Refraction Bulge | Controls the refraction strength (optical distortion) of the meniscus droplet.<br/><br/>Higher values bend the background pixels (Snell's Law), causing extreme lensing and total internal reflection at the edges. Lower values look like flat, undisrupted glass, Negative values intert the refraction. |
| Reflectivity | The base reflectivity (Fresnel R0) of the wet meniscus lens.<br/><br/>Higher values make the droplet highly reflective (mirror-like), reflecting more of the skybox/environment probe. Lower values keep the droplet mostly transparent. |
| Specular Intensity | Controls the brightness of the directional light specular glint on the meniscus.<br/><br/>Higher values create a bright sun highlight when the camera looks towards the directional light at the waterline. Lower values dull the highlight. |
| Specular Power | Controls the sharpness and focus of the specular glint on the meniscus.<br/><br/>Lower values (e.g., 16-64) spread the sun's reflection out into a wide, wet smear across the lens. Higher values (e.g., 256-512) tighten the highlight into a microscopic, sharp pinpoint. |
| Chromatic Dispersion | Splits the RGB light (chromatic aberration) when refracting through the meniscus droplet.<br/><br/>When enabled, the droplet samples three slightly different indices of refraction, causing a prismatic rainbow fringing effect at the edges of the water band. |

#####  Scattering (Fog)

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_scattering.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Body Scattering | Sun scatter on flat wave troughs. |
| Tip Scattering | Sun scatter on wave crests. |
| Height Scattering | Ambient height term scale (matches surface Height Scattering). |
| Displacement Scattering | Ambient chop term scale (matches surface Displacement Scattering). |
| Scattering Wave Height | Reference wave height for ambient scatter terms (matches surface Scattering Wave Height). |

<a name="volumetric-lighting-settings"></a>
##### Volumetric Lighting

Screen-space underwater volumetric light shafts (godrays) for URP and Built-in. When enabled on [Under Water Settings](#underwater-settings), the system raymarches the water column into a low-resolution buffer that [Underwater Effect](#underwater-effect) composites over the scene.

The effect follows the main directional light and can be modulated by shadow casters, temporal denoise, caustics-driven shaft breakup, and a post-resolve blur. Tune quality with sample count and buffer resolution.

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/underwater_volumetric.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

| Property | Description |
| :--- | :--- |
| Enable | Raymarches the underwater volume with the main light to create godrays / light shafts. |
| Intensity | Brightness of the volumetric light shafts. |
| Anisotropy | How tightly the shafts concentrate toward the sun.<br/><br/>Higher values make sharper godrays. Lower values spread the glow more widely. |
| Density | How much light scatters along each raymarch sample. |
| Sample Count | Number of raymarch steps.<br/><br/>Higher is smoother but more expensive. Compiled as a shader keyword so the march loop can unroll. |
| Resolution | Buffer size relative to the screen.<br/><br/>Quarter is cheapest. Half is sharper. Full matches the screen and costs the most. |
| Use Shadows | Modulate the shafts with the main light shadow map so occluders cast volumetric shadows. |
| Temporal Denoise | How much of the previous frame to reuse when cleaning up dither noise from the low sample count.<br/><br/>Higher values look smoother but take longer to catch up when the lighting changes. Set to 0 to disable temporal reuse. |
| Shaft Strength | Carves wave-driven beams out of the shafts instead of a smooth glow.<br/><br/>Reuses this surface's caustics texture and tiling, projected up the light direction, so the beams in the water and the caustics on the seafloor are the same pattern. Set to 0 to leave the shafts shaped only by shadow casters. |
| Shadow Breakup | How strongly geometric shadow shafts break into filaments near occluder edges.<br/><br/>Set to 0 for clean shadow-map shafts. |
| Breakup Scale | World scale of the breakup pattern.<br/><br/>Higher values make finer filaments. |
| Breakup Speed | How fast the breakup pattern scrolls. |
| Blur Radius | Gaussian blur radius in texels, applied after resolve for display only.<br/><br/>Softens leftover sparkle from the low sample count without smearing the temporal history. Set to 0 to disable. |

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

| Property | Description |
| :--- | :--- |
| Caustics Enabled | Controls whether the [Caustics Effect](#caustics-effect) is currently enabled. |

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
| Texture Intensity | The brightness multiplier for the projected caustics texture.<br/><br/>An independent scalar specifically for the animated texture component of the effect.<br/>Zero disables the [Fluid Render Pipeline](#fluid-render-pipeline) shader variant (no flipbook samples). |
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
| Darkness | Controls how much the sea floor is darkened in the areas between light patterns.<br/><br/>Increasing this value darkens the "caustic shadows," making the bright light patterns appear more high-contrast and prominent. |
| Shadow Intensity | Controls the visibility of caustics within areas shadowed by external light sources.<br/><br/>A value of 0 makes caustics completely invisible in shadow, while a value of 1 allows them to remain fully visible. |
| Surface Fade-In | Defines the depth range near the surface where the caustics begin to appear.<br/><br/>The X value represents the depth where the effect starts, and the Y value is where it reaches full intensity. This prevents visual "popping" at the water line. |
| Depth Fade-Out | Defines the depth range where the caustics gradually disappear as light is absorbed.<br/><br/>The X value is the depth where fading begins, and the Y value is the depth where caustics are completely extinguished. |
| Foam Masking | Controls how much surface foam occludes the caustics on the seafloor.<br/><br/>Simulates the diffusive nature of bubbles. Thick foam scatters light, preventing sharp caustics from forming and casting a soft shadow on the environment below. |
| Half Resolution | Renders caustics at half screen resolution and upsamples before compositing. Large GPU win; slightly softer patterns. |


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
| Reflections Enabled | Controls whether real-time planar reflections are generated for this water surface. |
| Resolution | The quality/resolution of the generated planar reflection texture. |
| Culling Mask | Which layers the planar reflection camera renders. |
| Clear Flags | What to display in empty areas of the planar reflection's view (e.g., Skybox, Solid Color). |
| Clip Plane | A vertical offset to apply to the reflection plane. This can be used to prevent clipping artifacts with the water surface. |
| Smooth Position | Smoothes the reflection plane's height and position over multiple frames to prevent jittering caused by rapid fluid simulation updates. |
| Smooth Speed | How fast the reflection plane adapts to water height changes. Lower values result in smoother, slower transitions. |
| Snap Threshold | The height difference threshold at which the reflection plane instantly snaps to the new height instead of smoothly transitioning. |
| Renderer ID | SRP Renderer to use for the planar reflection pass. Use this to select a cheaper render pass for the reflection camera. |
| Shadow Quality | Controls shadow rendering in the reflection (BiRP Only). |
| Reflection Texture Size | Defines the resolution/size of the generated reflection texture. |


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
| Under Lava Enabled | When enabled, the [Under Lava Effect](#under-lava-effect) applies a depth-based tint while the camera is inside this lava volume. |
| [Under Lava Settings](#under-lava-settings) | Tunables for the under-lava volume tint (absorption only). |
| Generate Heat Lut | If enabled, the `Heat` gradient will be used to procedurally generate a **Heat LUT** that overrides the existing LUT on the [Fluid Renderer](#fluid-renderer). |
| Heat | The `Gradient` used to define the heat/color transition for the lava. The color samples are mapped from Cold Lava (Left side of the gradient) to Hot Lava (Right side of the gradient). |

<a name="under-lava-effect"></a>
#### Under Lava Effect

Renders a depth-based tint when the camera is inside a [Lava Surface](#lava-surface) volume, using the same mask and depth data as the underwater effect, with an optional surface band (meniscus-style thickness).

<a name="under-lava-settings"></a>
##### Under Lava Settings

| Property | Description |
| :--- | :--- |
| Composite Mode | Chooses how the under-lava pass blends the volume with the scene.<br/><br/>Options include:<br/>- **`Opacity`** <br/> Linear blend toward `Volume Color` using `Opacity`; no depth-based extinction.<br/> <br/>- **`Absorption`** <br/> Depth-varying absorption using `Volume Color`, `Absorption Depth Scale`, `Absorption Limits`, and optional `Absorption Ambient Color` / `Absorption Ambient Strength`. |
| Volume Color | Tint color. In opacity mode, RGB is blended in; in absorption mode, it drives extinction (see absorption remarks). |
| Opacity | Opacity mode only: blend strength between the scene and `Volume Color` (0 = scene only, 1 = full tint). |
| Depth Transparency | Absorption mode only: scales how strongly absorption increases with optical depth.<br/><br/>RGB of `Volume Color` drives extinction; alpha scales strength with `Absorption Depth Scale`. |
| Depth Limits | Absorption mode only: clamps the absorption luminance (Min, Max). |
| Ambient Color | Absorption mode only: color the view fades toward through the volume (instead of black), mixed by `Absorption Ambient Strength`. |
| Ambient Strength | Absorption mode only: how much the ambient tint is added as transmittance drops (0 = multiply-only / fade to black, 1 = full blend toward `Absorption Ambient Color`). |
| Thickness (cm) | Thickness of the surface band at the lava line (centimeters), 0 disables. |
| Rim Color | Hot-edge tint added in the surface band (HDR). |
| Rim Intensity | Strength of the rim glow in the surface band. |

___

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

<a name="fluid-shaders"></a>
