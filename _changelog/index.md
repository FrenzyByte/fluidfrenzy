---
title: Changelog
permalink: /changelog/index/
redirect_from: /changelog/index.html
---
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2025-10-26

### Reimport the Samples if you encounter compile errors in the sample code.

### Added
- Simulation: Multi-layer terraforming. Control up to 4 Terraform/Erosion layers with each layer having a wide range of properties on how they interact with the fluid. See TerraformFlow for some examples.
- Simulation: Fluid Mixing controls to allow the user to decide which layer the mixed fluid turns into and which rate.
- Simulation: Added Liquify mode to Terraforming. Turn terrain into a fluid over time. For example melting snow.
- Simulation: Saving and loading of simulation data.
- Simulation: Terraform Modifier modes for add/set/max/min blend modes.
- Rendering: New Terraform Terrain shader which makes use of Texture2DArray to allow multiple layers.
- Editor: Texture Atlast Creator tool in Window > Fluid Frenzy menu which can be used to create a Texture2DArray for the new Terraform Terrain shader.
- Editor: TerrainModifierEditor to a cleaner inspector and gizmos previewing the effect of the modifier.
- Editor: Auto update code for ErosionLayer and TerraformLayer to initialize them with the new settings.

### Changed
- Simulation: Apply Fluid/Terrain input using ColorMask to reduce number of shader passes.
- Simulation: Disable Overshooting reduction by default.
- Simulation: Match advection of sediment to other advection effects like foam and flow.
- Rendering: Renamed old Terraform Terrain shader to Terraform Terrain(Single Layer).
- Editor: Moved Terraform/Erosion editors to the correct folder.
- Editor: Converted Falloff property to slider on Fluid and Terrain Modifiers.
- Samples: TerraformFlow has been updated with new Multi-layer terraform settings. Mud and snow has been added, as well as volcanic rock on lava contact.

### Fixed
- Simulation: Obstacle movement when using TerraformLayer/ErosionLayer causing fluids to shake violently for a few frames.
- Simulation: Padding when sampling velocity in hydraulic erosion and sediment advection.
- Simulation: Padding on Fluid Modifier input.
- Simulation: Texture source mode for Terrain Modifier.
- Rendering: SimpleTerrain sets Obstacle property to Texture2D.black to not add height of 1.

## [1.2.12] - 2025-09-28

### Reimport the Samples if you encounter compile errors in PlayerBoat.cs

### Added
- Simulation: New FluidRigidBody system that applies more physically correct splashes/wakes in the simulation and buoyancy/drag/lift to the RigidBody component.
- Simulation: FluidSimulationLoop which is a custom PlayerLoop that manages and updates the FluidSimulation.
- Simulation: Conservative rasterization pass to FluidObstacles to create a tighter fit around obstacles. Only used on platforms that support geometry shaders.
- Simulation: FluidDebugViewer script and prefab which can be dropped into the scene to have onscreen debugging.
- Samples: New PlayerBoat script that uses FluidRigidBody.

### Changed
- Simulation: Renamed the old FluidRigidBody to FluidRigidBodyLite as it is a simpler and lighter version more appropiate for Web and Mobile.
- Simulation: Removed option runInFixedUpdate from FluidSimulationSettings. Instead place it behind the FLUIDFRENZY_RUN_UPDATE scripting symbol.
- Simulation: Small optimizations to readback data calculation.
- Samples: Renamed PlayerBoat to PlayerBoatLite.

### Fixed
- Simulation: Obstacle->Fluid mismatch due to introduction of padding and tiling.
- Simulation: Fluid leaking when using FluxFluidSimulation with FluidWavesModifier.
- Simulation: Tiled simulation mismatch/seam when adding fluid on a border.
- Rendering: URP modes without color and depth buffers during planar reflections and screenspace particles.

### Fixed
- Simulation: Disable Terraform Mixing particles in WebGPU as there are bugs with Unity's experimental implementation of WebGPU.
- Simulation: Apply same fluid input in WebGL as in WebGL mobile, as Unity have not implemented fp32 blend modes correctly yet. [Issue-50](https://github.com/FrenzyByte/fluidfrenzy/issues/50)
- Rendering: Correct Terrain sampling during creation of Renderdata, fixing the broken normals. [Issue-50](https://github.com/FrenzyByte/fluidfrenzy/issues/50)

## [1.2.11] - 2025-08-10

### Added
- Simulation: Added support for fluid mixing when using Unity Terrain system. Terraforming is still not supported.

### Fixed
- Simulation: Disable Terraform Mixing particles in WebGPU as there are bugs with Unity's experimental implementation of WebGPU.
- Simulation: Apply same fluid input in WebGL as in WebGL mobile, as Unity have not implemented fp32 blend modes correctly yet. [Issue-50](https://github.com/FrenzyByte/fluidfrenzy/issues/50)
- Rendering: Correct Terrain sampling during creation of Renderdata, fixing the broken normals. [Issue-50](https://github.com/FrenzyByte/fluidfrenzy/issues/50)

## [1.2.10] - 2025-08-01

### Changed
- Simulation: Apply horizontal limiter to particles based on height change in waves.
- Simulation: Exposed UpdateTerrain function so the simulation can be refreshed with a updated Unity Terrain.
- Editor: Error when not settings are assigned to the FluidSimulation component.
- Samples: Convert Volcano sample to FlowFluidSimulation.

### Fixed
- Simulation: Flip Y sampling in Boundary Copy in OpenGL.
- Simulation: Closed border Boundary copy only copies single row of pixels, not all.
- Simulation: Allow FluidSimulation MeshCollider mode to capture meshes higher than 1000 meters.
- Simulation: Allow FluxFluidSimulation tiled simulation to work without Velocity Padding. It is still recommended to use the Velocity Padding for quality reasons.
- Simulation: Android precision issue preventing height from going higher than 32 meters when using low additive increments.
- Rendering: Non-Tiled texture sampling seam artefact on the edges of neighbouring terrains.
- Rendering: Water shader in URP VR mode.
- Editor: Disable drawing base GUI of FluidLavaShaderGUI.

## [1.2.9] - 2025-07-18

### Changed
- Simulation: Improve the velocity of the splash particles to match the scale of the simulation better.

### Fixed
- Rendering: URP + Unity 6000.1 Water.shader error for missing FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK define.

## [1.2.8] - 2025-07-12

### Added
- Rendering: ShaderGraph support to allow users to create custom shaders. See the documentation for more information about the nodes.
- Rendering: [Beta] HDRP Support to Water Shader.
- Rendering: [Beta] HDRP Water System mode to the WaterSuface script to allow users to use the fluid simulation with the built-in HDRP Water System.
- Rendering: [Beta] HDRP Shaders for Lava, TerraformTerrain and ProceduralParticle using ShaderGraph.
- Rendering: Refraction Screenspace Absorption mode to water shader that behaves more like correct water absorption.

### Changed
- Rendering: Renamed Screenspace refraction mode to Screenspace Tint.
- Simulation: Improved edge detection when creating fluid simulation renderdata, reduces clipping on shallow edges.
- Simulation/Rendering: Rename FLUID_UNITY_TERRAIN keyword to _FLUID_UNITY_TERRAIN.
- Rendering: Renamed Flowmapping shader keywords.
- Rendering: Added common headers for TerraformTerrain so they can be re-used by users and shadergraph.
- Rendering: Added common headers for ProceduralParticle so they can be re-used by users and shadergraph.
- Rendering: Apply GPULOD Transform directly instead of overriding the unity_ObjectToWorld matrix.

### Fixed
- Simulation: Simulation delta time step check so that smaller steps can be done when possible.


## [1.2.7] - 2025-06-01

### Added
- Simulation: Tiling support for FlowFluidSimulation.
- Editor: Toggle for neighbour handles in sceneview.
- Editor: Buttons to Add and Disconnect FluidSimulation neighbours through the inspector.

### Changed
- Simulation: Improved tilling support in FluxFluidSimulation.
- Simulation: Remove requirement of scripting define to use tiled simulation logic.
- Simulation: Improved terrain unity initialization/copy by copying bordering pixels in seperate pass instead of scaling and repeating, improves the edges of the simulation.
- Simulation: FluidFlowSimulation open/closed borders is handled with custom blits, simplifies the main pass and allows more control for each border separately in the future.
- Simulation: Remove compute dependency so all logic is the same and works on each platform.

### Fixed
- Simulation: FlowFluidSimulation stability enhancements average using correct samples, was using bottom twice.
- Simulation: Hydraulic erosion with FlowFluidSimulation.
- Simulation: Fluid input on WebGL + IOS.
- Rendering: Foam layer sampling by using the correct 0 to 1 UVs.
- Rendering: ProceduralParticle shader compilation in BRP.
- Rendering: TerraformTerrain shader compilation in BRP.
- Editor: Gamma control in FluidSimulation debugger.
- Samples: Mouse3D in WebGL + URP.

## [1.2.6] - 2025-05-10

### Added
- Rendering: Curved World support on water, lava, particles, and terraform terrain shader.
- Simulation: Maximum bend mode to FluidModifierVolume Source mode.
- Simulation: Damping blend mode to FluidModifierVolume Flow and Force mode to dampen waves and velocity field.

### Changed
- Editor: Draw all modes of the FluidModifierVolume separately.

### Fixed
- Simulation: FluidFoamModifier adds foam to the correct channel.
- Simulation: FluidEventTrigger reporting of height and depth.
- Simulation: Add up to 2x2 downsample support to WebGL so it will match other platforms better.

## [1.2.5] - 2025-05-03

### Added
- Simulation: Mode to capture layers as a heightmap. The option allows you to select and setup a LayerMask to choose which objects should be rendered to the heightmap used for the fluidsimulation.
- Simulation: FluidModifierVolume blend modes for source and velocity. Choose between Additive, Set, and Minimum blendmode to have better control over the behaviour of the fluid simulation.
- Simulation: FluidModifierVolume source option to select which space to modify the fluid height in, World or Local space.
- Simulation: FluidModifierVolume Flow Texture support. Assign a Flowmap to Add or Set velocity to the fluid simulation.
- Simulation: Distance Field for finding and sampling the nearest Fluid Simulation location.
- Simulation: Fluid depth to FluidEventTrigger.
- Rendering: Water material presets.
- Rendering: URP Soft shadow support on water shader.
- Rendering: URP PlanarReflection Renderer ID support to set cheaper passes for planar reflection rendering.
- Rendering: Enviro3 Support in Planar Reflections.
- Editor: ShaderStripper to reduce the number of shader permutations. Reduces URP build time and size by 80%.
- Editor: FluidModifierVolume Flow visualizer by drawing arrows of the selected direction.

### Changed
- Simulation: Match Foam and Particle turbulence control so particles and foam can spawn similarly when the conditions and setup are met.
- Simulation: Remove a speed limiter from Particle Generator.
- Simulation: Optimized FluidRigidBody by caching transforms, position, rotation and reduces overal interfacing with the Unity Engine.
- Simulation: Optimized FluidSimulation Readback by caching transforms, rendertextures and other static data.
- Simulation: Removed Additive mode from FluidModifierVolume and replaced it with a Blend Mode option.
- Simulation: Use ClipHeight in FlowFluidSimulation like FluxFluidSimulation does.
- Simulation: Do not allocate the RAM for the CPU>GPU Readback when it is not enabled.
- Simulation: Match FluidRigidBody and FluidParticleGenerator advection.
- Rendering: Optimized the number of shader permutations on the water and lava shader to improve build time and size.
- Rendering: Planar reflection lodding.
- Rendering: Use nearest Fluid location Height for Planar Reflections when available.
- Editor: FluidModifierVolume draws the direction as angle/degrees instead of a vector2 to make it easier to change direction.
- Editor: Set the debugger to point filtering to see the raw data.

### Fixed
- Simulation: initialFluidHeight texture when used with Unity terrain.
- Simulation: FluidEventTrigger reporting of height and depth.
- Simulation: MeshRenderer Obstacle rendering with the FluidSimulation is not at 0 height.
- Simulation: Cover the full 0 to 1 range with a better random number generator for Fluid Particles.
- Simulation: Process FluidModifiers after setting all global properties to prevent uninitialized behaviour on the first simulation frame.
- Rendering: URP FluidParticle shader particle rotation.
- Rendering: FluidParticleGenerator layer check in URP.
- Rendering: Changed Fluid Simulation rendering inputs to Texture2D instead of Sampler2D to lower the number of samplers used and prevent errors in URP with Enviro3 enabled.
- Rendering: SamplerTextureStaticLOD flowmapping function to use the correct UV channel.
- Editor: URP build error in RenderPipelineAutoUpgrader.
- Editor: Grid Gizmo placement when the FluidSimulation is not at 0 height.
- Editor: Default FluidSimulation and FluidRenderer/Material values when adding FluidSimulation through the context menu.

## [1.2.4] - 2025-04-11

### Fixed
- Simulation: FlowFluidSimulation in WebGL compute shader error.
- Rendering: Reduce number of layers in TerraformTerrain shader when running WebGL.

## [1.2.3] - 2025-04-06

### Added
- Simulation: FluidParticleGenerator. A GPU Accelerated particle system to create splash and surface particles based of the Fluid Simulation Data.
- Rendering: New ProceduralParticle and ProceduralParticleUnlit shader with more control over colors, blending and billboard orientation.
- Rendering: Added size and angular velocity min max control to particles.
- Rendering: Support for Orthographic Rendering.
- Rendering: Water opaque render mode for users who do not need the water to be transparent or have refraction.
- Rendering: Foam Modes to have more options on how to render the foam, users can now choose between albedo(previous default), clip, and mask to have variance in their foam look.
- Rendering: Reflectivity offset control to make the water look more reflective on sharp angles.
- Rendering: Culling layer control to GPU Particles.
- Samples: Added FluidParticleGenerator to River and RiverFlow scene to demonstrate the effect.

### Changed:
- Simulation: Made improvements to obstacle merging with Unity Terrain to reduce clipping.
- Simulation: Improved random number generation for particles, both cheaper and better uniform coverage.
- Simulation: Optimized GPU Particle System by packing data and only rendering active particles.
- Simulation: FlowFluidSimulation removed custom delta limit by implementing proper stability enhancements as described in the paper.
- Simulation: Reset GPU Particles using Compute instead of setting data with big c# buffer allocations.
- Rendering: Renamed old ProceduralParticle shader to ProceduralParticle(Legacy) so old projects still work but it is advised to use the new ProceduralParticle shaders
- Editor: Added and improved tooltips for shaders.

### Fixed
- Simulation: Fluid Trigger Event now properly calls events when fluid enters/exits the trigger.
- Simulation: FluidModifierSource non-additive mode when using Unity Terrain and Vulkan.
- Rendering: Reflection probe sampling when using URP Forward+.
- Editor: Errors in RenderPipelineAutoUpgrader when building in URP.

## [1.2.2] - 2025-03-31

### Fixed
- Simulation: WebGL browser crash when using Unity Terrain.
- Simulation: Fixed Fluid Flow simulation when using Unity Terrain on Vulkan/GL platforms.
- Simulation: Unity terrain height on Vulkan. 
- Rendering: WebGL Refraction/Reflection sampling upside down.
- Rendering: Alpha blend mode in URP.

## [1.2.1] - 2025-03-16

### Added
- Simulation: Fluid Regions, users can now place simulations that do not match the bounds of the terrain, allowing smaller and more concentrated fluid simulations, like a river or lake on the terrain instead of the whole terrain. This is useful to have higher quality fluid simulations in select areas.
- Simulation: Non-square fluid simulations. Fluid Simulations can now be non-square which is useful for following regions like long rivers, saving performance and increasing quality along the river.
- Simulation: Support for procedural shape FluidSimulationObstacle to allow users to block fluid without using a Unity's Renderers.
- Simulation: FluidEventTrigger that triggers and reports when fluid enters/exits the trigger and reports the amount of fluid in that location.
- Simulation: Evaporation control to linearly and exponentially reduce the amount of fluid to simulate evaporation.
- Rendering: More 2 layers to Terraform Terrain shader to fully utilize the splatmap.
- IO: [Beta] Saving and Loading of Terraform Terrain as .exr and .png.
- Editor: Fluid simulation debugger to show information and visualize the buffers of a Fluid Simulation.
- Editor: HelpURL attribute added to reference scripts in documentation.
- Editor: More tooltips for FluidModifierWaves, FluidParticleSystem, and FluidSimulationSettingsEditor and many other scripts that missed them.
- Editor: Improvements for obstacles, allowing addition through context menu.
- Editor: Show a estimation of the start fluid height.
- Script: Added version to all components so they can be automatically upgraded when something drastic needs changing.

### Changed
- Simulation: More improvements to the advection of velocity, foam, and flowmapping to match closer with the FluxFluidSimulation waves so no tweaks need to be made to have the effects coupled. A advection speed/scale of 1 now matches the base simulation.
- Simulation: Exposed field to select the number of particles on the Terraform Layer.
- Simulation: Grab the maximum height of the terrain when the Fluid Simulation has a smaller resolution than the Unity Terrain to improve the quality of the simulation.
- Editor: Improved the visual of the component's editors.
- Editor: Allow expanding of settings scriptable objects directly in the Fluid Simulation component for easier editing.

### Fixed
- Simulation: Open Border logic on FlowFluidSimulation when the simulation starts without fluid.
- Simulation: FlowFluidSimulation Top and Right border properly reflect on boundaries when Open Border is disabled.
- Simulation: Loading of the correct pass when initializing the Fluid Simulation with Unity Terrain.
- Rendering: Enviro3 asset location will automatically be detected if it is not found at the default location.

## [1.2.0] - 2025-02-15

### Added
- Simulation: New fluid simulation mode called FlowFluidSimulation. This is a higher simpler to use and performant simulation. This new simulation supports all features where applicable that the other simulation used as well and most components are usable in both simulations.
- Simulation: FlowFluidSimulationSettings scriptable object that is extension of the base FluidSimulationSettings class to add FlowFluidSimulation specific settings.
- Simulation: Added new foam inputs: Turbulence which looks at local difference in the velocity field and Shallow Velocity which looks at water depth and velocity.
- Samples: RiverFlow and TerraformFlow sample scenes that demonstrate the new FlowFluidSimulation.

### Changed
- Simulation:Improve advection of velocity, foam, and flowmapping to match closer with the FluxFluidSimulation waves so no tweaks need to be made to have the effects coupled. A advection speed/scale of 1 now matches the base simulation.
- Simulation: Renamed FluidSimulation to FluxFluidSimulation and made FluidSimulation a base class that other simulations can derive from.
- Simulation: Renamed FluidSimulationSettings to FluxFluidSimulationSettings and moved Flux specific settings to the new class.
- Simulation: Match size of all FluidSimulation buffers so there are better one to one translations.
- Simulation: Split up FluidSimulation specific code into their own directories.
- Simulation: Made FoamLayer use single channel rendertarget due to new foam inputs.
- Simulation: Merged FoamLayer decay to single values instead of per channel as there is now only one channel.
- Simulation: Pack shader variables together into single variables to reduce the number of variables needing to update in C#.
- Simulation: Refactored FluidModifierWaves to use Gerstner wave math as a input to generate a wave field which has better and clearer controls. Note these are not real gerstner waves, but the functions returned nice outputs that can be used in both FluxFluidSimulation (Y) and FlowFluidSimulation (XZ). The previous implementation of this component has been renamed to FluidWavesModifierLegacy for backwards compatibility.
- Shaders: Make all shaders include headers based on the package directory instead of relative to the shader's file location.
- Rendering: Default PlanarReflection clear mode to Skybox.
- Samples: Upgraded samples to use the new FluidModifierWaves component due to refractor.

### Fixed
- Simulation: FluidModifierWaves caused vibrations due to low floating point precision buffers, increase the precision to 16bit.
- Rendering: TerraformTerrain Vulkan Compile errors.
- Rendering: Lava Shader missing in right eye by adding support for single Instanced/Pass Stereo rendering.
- Rendering: Water shader stereo instanced depth reading so absorption and refraction is correct in both eyes.
- Rendering: Android refractions being flipped when in portrait mode.
- Samples: Build error in RockSphereEffect.shader when building for VR.

## [1.1.3] - 2025-01-19

### Added
- Rendering: Stereo Instanced GPULOD (Terrain + Fluid) Support.
- Rendering: Stereo Instanced Planar Reflection.
- Rendering: Stereo Instanced Water Refraction.
- Samples: GPULODTerrain sample that shows rendering of a simple terrain.

### Changed
- Rendering: URP Terrain sample normals in Pixel shader same as Built-in renderpipeline.
- Editor: Give SimpleTerrain the same GUI as TerraformTerrain.

### Fixed
- Rendering: Fixed fog not working in Built-in renderpipeline.
- Rendering: GLES3 Build duplicate instancing attribute error.
- Rendering: TerraformTerrain shader compile error when targeting Vulkan.
- Rendering: Built/Standalone GPU Particles "Unable to create ProceduralQuad Index Buffer" error.
- Rendering: URP VR compile errors when building.
- Rendering: Unity 2021.1, 2021.2, 2022.1 "CopyMatchingPropertiesFromMaterial" compile error.
- Samples: Build error in RenderPipelineAutoUpgrader.

## [1.1.2] - 2025-01-04

### Added
- Unofficial support for Unity 2020. The asset is functional now in Unity 2020 but due to differences in API not all features may work the same as later versions.
- Simulation: Added version to FluidSimulationSettings so it can be upgraded easier.

### Fixed
- Simulation: Obstacles are now functioning as expected on the first load of the asset. Previously obstacles would cause a corrupted simulation due to uninitialized values.
- Simulation: FluidModifierVolume setting fluid amount is now set correctly on FluidSimulation's that use the Unity Terrain.
- Rendering: FluidSimulationDebug shader.
- Rendering: Fix detail waves flow mapping in Built-in renderpipeline water shader if foam is not assigned.

## [1.1.1] - 2024-12-24

### Added
- Simulation: Support for `MeshCollider` as simulation base ground.
- Simulation: Support for setting fluid to a specific height in an area based on the `FluidModifierVolume` height.
- Simulation: Support for square input mode.
- Rendering: Added clipspace offset to URP water and lava shaders.
- Editor: Tooltips added to `FluidSimulationEditor`.

### Changed
- Simulation: Smooth out the rendering mask for better shapes between fluid layers.
- Rendering: Improved lava and water edge smoothness by sampling the mask in the fragment shader.

### Fixed
- Simulation: Second layer not leveling fluid around edges.
- Rendering: Lava flowmapping resetting incorrectly due to tiling reduction.
- Rendering: Automatically set texture keywords enabled when creating new material.
- URP: Prevented enqueueing traverse pass unless it's the scene view or main camera.

## [1.1.0] - 2024-12-12

### Added
- Rendering: Support for Universal Render Pipeline.
- Rendering: Ambient lighting support for Lava shader.
- Editor: Automatic Pipeline upgrader for each sample so samples can be used in both Built-in and Universal Render Pipeline.
- Editor: Warnings and tooltips for URLS on the Fluid Frenzy About Window.

### Changed
- Rendering: Restructured shader to split rendering shaders (Water, Lava, TerraformTerrain) into headers between shared, built-in and urp.
- Rendering: Renamed old terrain shaders to FluidFrenzy/Legacy as they were previously superseded by TerraformTerrainShader.
- Rendering: Remove unused shader variants from Lava, Water and TerraformTerrain shader as they weren't used but did increase compilation size.
- Rendering: Reduce water shader specular intensity. Intensity was 25 times over-bright than what it should be causing bloom to be very intense. Specular now matches regular PBR. Users who still want a brighter specular can modify the intensity on the material as before.
- Samples: Simplified some sample shaders.
- Samples: Removed bloom clamping after modifying specular intensity.

### Fixed
- Rendering: Tiling artefact when using Tiled Simulations with the lava shader.
- Rendering: Compilation errors when enabling fog on the TerraformTerrain shader.
- Rendering: Normalize the TerraformTerrain splatmap sampling to prevent weights higher than one when layers are on top of each other.
- Rendering: Soft shadows on Lava shader.
- Editor: Remove warning in Unity 2023 for FluidModifierVolumeEditor.
- Samples: Compilation error when enabling fog on RockSphereEffect.
- Samples: Artefact on RocKSphereEffect shader in certain locations in the world.

## [1.0.9] - 2024-11-21

### Added
- Simulation: Physics Collider and raycasting support by optionally generating a TerrainCollider for the TerraformTerrain/SimpleTerrain and FluidSimulation.
- Rendering: Water shader fade slider to allow height based fading similar to the lava shader to soften edges.

### Fixed
- Rendering: Incorrect dimensions being assigned the FluidRenderer components.
- Rendering: Debug shader rendering when using vulkan.
- Simulation: OpenGL triangle spikes due to render data creation not sampling neighbors correctly.

## [1.0.8] - 2024-11-10

### Added

- Rendering: Support for [Enviro3 Sky and Weather](https://assetstore.unity.com/packages/tools/particles-effects/enviro-3-sky-and-weather-236601) in lava and water shader.
- Simulation: Splash particles to FluidRigidBody for spawning particles when the object hits the fluid surface.
- Samples: Added falling objects to WaterModifiers scene to demonstrate Splash particles.

### Fixed

- Rendering: GPULOD Shadow culling. Objects no longer get culled too early when facing away from light direction.
- Rendering: Error when creating a Terraform terrain.
- Rendering: Error when no Shadow Light is assigned to SimpleTerrain.
- Rendering: Match Simple/Terraform terrain texture to the spplied heightmap when using GPULOD mode.
- Simulation: Tiled rendering seams removed. Neighbouring simulation's texture sampling is now seamless.

## [1.0.7] - 2024-10-26

### Added

- Rendering: A new GPULOD terrain/fluid renderer rendering system based on the Quadtrees on the GPU paper. This is a fully GPU accelerated LOD system which will help improve the rendering performance of the fluid and terrain rendering.
- Rendering: Added support for rendering SimpleTerrain and TerraformTerrain in the scene view without going into play mode.
- Rendering: Deferred shading support in the TerraformTerrain shader.
- Rendering: Shadow support on the Lava shader.
- Rendering: Hard shadows on the Water and Lava shader.
- Rendering: Instancing support for the Lava and Water Shader.
- Rendering: Chunk/Block splitting support to the SimpleTerrain and TerraformTerrain component to improve terrain culling.
- Rendering: Shader API headers to easily write custom or add new shaders that interact with the FluidSimulation. Users that wish to write their own fluid surfaces for example stylized water can now do so by including the following headers: FluidRenderingCommon.hlsl
- Simulation: Exposed many scripting API functions to make it easier to create and interact with the FluidSimulation and it's many components.
	- Add/Get/Set/Gather Neighbour functions to setup and interact with neighbours.
	- FluidSimulationManager.Step to manually progress all FluidSimulation components available
- Samples: Added a RuntimeSetup example to demonstrate how to setup a FluidSimulation at runtime through C# scripting.
- Samples: Added a Tiled Simulation example to demonstrate how to use the neighbouring tile functionality.
- Samples: Added a Simple Terraform example to demonstrate terra-forming with more reusable scripts in users own games/scenes.
- Editor: Added Tooltips to many of the rendering, simulation and shader GUIs.
- Documentation: Added comments to all FluidFrenzy public classes, functions and properties to help users interact with FluidFrenzy's many compnents.

### Changed

- Rendering: Rendering method for FluidRenderer, SimpleTerrain, and TerraformTerrain. It is now possible to select different rendering modes (MeshRenderer, DrawMesh, GPULOD). Scenes will be automatically upgraded to the new method.
- Rendering: Optimized Lava shader by reducing texture reads when using texture tiling reduction.
- Simulation: Step function to allow more steps to be ran in a single Step call for users who wish to progress the simulation manually.
- Simulation: Refactored and moved code into partial classes for better organization and readability.
- Simulation: Hidden fluid simulation shaders from the shader selection menu in the material inspector.
- Simulation: Reduce maximum allowed padding to 50%.
- Samples: Make River & Terraform scene use new GPULOD system as an example.
- Documentation: Updates across various components to enhance clarity.

### Fixed

- Rendering: Garbage collection when using CPU Readback.
- Rendering: Normal calculation in TerraformTerrain shader.
- Rendering: Seams between FluidSimulation tiles due to incorrect UV sampling.
- Simulation: Improved parameter naming consistency across multiple components.
- Simulation: Incorrect UV sampling of dynamic flow mapping on edges with simulation neighbours.
- Simulation: Warning in Unity 6.
- Samples: Garbage collection issues in various scripts and components (UIController and Mouse3D).

## [1.0.6] - 2024-09-16

### Added

- Rendering: Clipping offset controls to Lava and Water shader. This allows the user to reduce clipping with the Unity Terrain on lower LODs.
- Rendering: Albedo texture support to lava shader for when the lava is cold.
- Rendering: Slider to control the light intensity of Lava lighting.
- Rendering: Fade Height slider to control to the lava shader transparency. This allows the user to soften the lava's edges. 
- Simulation: [Beta]Added support for neighbouring simulation interaction. See [documentation](https://frenzybyte.github.io/fluidfrenzy/docs/tiled_simulations_beta/) for more information. [Issue-10](https://github.com/FrenzyByte/fluidfrenzy/issues/10)
- Simulation: Fluid Base Height option. This allows offsetting the height of the fluid in the Y direction in order to fix clipping issues with tessellated Unity Terrains.[Issue-12](https://github.com/FrenzyByte/fluidfrenzy/issues/12) 
- Simulation: Support for adding simulation's at runtime. [Issue-6](https://github.com/FrenzyByte/fluidfrenzy/issues/6)
- Simulation: Functions to set and update the Fluid Simulation's terrain.
- Simulation: Support for dxc compiler. Automatically enabled when using XBOX. Can be overwritten by uncommenting the #define FORCE_DXC line in the common.hlsl headers. [Issue-11](https://github.com/FrenzyByte/fluidfrenzy/issues/11)
- Simulation: Improve visual feedback on Fluid Sources. Draw a grid matching the underlying terrain. [Issue-7](https://github.com/FrenzyByte/fluidfrenzy/issues/7)
- Editor: About window that popsup on first load or can be opened using Window > Fluid Frenzy > About.

### Changed

- Rendering: Lava Fade height is now performed from the Fluid Simulations Settings Clip Height as a start position instead of 0.
- Rendering: Moved Lava and Water textures to Runtime folder to improve workflow. When creating a Water/Lava simulation the materials will automatically have default textures assigned. This should prevent confusing when the simulation look worse/different than the samples. [Issue](https://github.com/FrenzyByte/fluidfrenzy/issues/4)
- Simulation: Linear filter the velocity field when creating rendering data, makes the velocity smoother.
- Simulation: Removed rotation from normal map, all heights are now sampled anyway. Reduces cost and makes normals more accurate.

### Fixed

- Rendering: Close Fit Shadows mode on FluidFrenzy/Water shader. [Issue-3](https://github.com/FrenzyByte/fluidfrenzy/issues/3)
- Rendering: normal map generation. Normals were angled too far down on slopes.
- Simulation: WebGL warnings.
- Simulation: GetHeight function to include the transform height. [Issue-8](https://github.com/FrenzyByte/fluidfrenzy/issues/8)
- Simulation: Bounds height calculation. Bounds are now twice the size of the supplied terrain in order to make GetHeight return more accurately. [Issue-9](https://github.com/FrenzyByte/fluidfrenzy/issues/9)
- Simulation: Update bounds when assigning a different terrain to the Fluid Simulation. [Issue-5](https://github.com/FrenzyByte/fluidfrenzy/issues/5)
- Simulation: Fixed Garbage allocation when using CPU Readback.
- Simulation: Vulkan errors when using FluidObstacles and FluidModifierWaves.
- Editor: Fixed the location of the Fluid Simulation when created through the Fluid Frenzy > Create Water Simulation option.
- Samples: Touch input improvements in samples, fixes poor performance on some low-end devices.

## [1.0.5] - 2024-08-28

### Added

- Editor: Create Lava Simulation context menu.
- Terraform Terrain: Allow not setting splatmap/heightmap.
- Simulation: Added optimization for shadermodel 4.0 targets (DirectX) or when using custom terrains by using Gather when creating renderdata.

### Changed

- Simulation: Changed Normal Map to 16bit floating point to improve quality of normals (reduce banding).
- Simulation: Removed rotation from normal map, all heights are now sampled anyway. Reduces cost and makes normals more accurate.
- Simulation: Clipping mask is now stored in normal.w.
- Samples: Set lava renderqueue to 2510.

### Fixed

- Simulation: Fixed clipping issue when using high terrains. High terrains would clip due to floating point imprecision, at higher values steps would get bigger and sometimes end up under the terrain. Resolved by storing water delta in renderdata and sampling both terrain and waterheight in water/lava shaders.  
- Simulation: Unity terrain is now stored in R16_Unorm (R8G8_Unorm in WebGL) so that the water and source unity terrain match.
- Simulation: Wave Foam is now generated from correct wave delta instead of low range/clamped value of normal.w.
- Simulation: Fixed Second Layer only "Addtive velocity". Previously when Additive velocity was only enabled on the second layer it would not be properly integrated.
- Samples: Move orbit camera framerate independent.

## [1.0.4] - 2024-08-15

### Added

- Terraform Terrain: Allow not setting splatmap/heightmap.
- WebGL: Added fallback mode to replace blend mode sources on iOS 16+ as fp32 blendmodes are bugged/not supported.
- Samples: Add Sandbox sample scene.
- Samples: Placing sources in samples.
- Samples: Mobile controls.

### Changed

- Simulation: Replace all shader half vectors with float
- Samples: Toolbar improvements and cleanup.
- Samples: General quality improvements.

### Fixed

- Simulation: Make simulation framerate indepedent again.
- Simulation: Reset static input when resetting the simulation.
- Foam: Make wave height foam generation consistent and indepedent of timestep size.
- Foam: If foam runs in RGHalf instead of UNorm on mobile platforms make sure it is clamped the same as desktop.
- WebGL: Fix fluid stretching up against walls on android devices.
- WebGL: Fix terrain source Max Blend (e.g. Terraform Volcano) on iOS 17.
- Samples: Fix black artefacts on volcano terrain in OpenGL.

## [1.0.3] - 2024-07-31

### Added

- [Beta] Added WebGL support. Should be fully functional except GPU particles on TerraformLayer.
- Option to add Vortex through GameObject > Fluid Frenzy context menu.
- Option to add Fluid Source for second layer through GameObject > Fluid Frenzy context menu.
- Draw Fluid Simulation and Simple/Terraform Terrain bounds in scene view.
- Added Toolbar to the samples to have a cleaner UI.
- Added bounds to the samples so the boat can't fall out of the scene. 

### Changed

- Simple/Terraform Terrain now gets initialized without needing a Fluid Simulation in the scene.
- Improve code for creation of simulation buffers.
- Tweaked buoyancy of boat now that the volume is corrected. 
- Automatically generate HeatLUT when creating a Lava Simulation through Fluid Frenzy context menu.
- Hide debug code behind `#if UNITY_EDITOR` completely.
- Initialize Lava and Terrain shaders to have higher default scale/tile settings when created through Fluid Frenzy context menu.

### Fixed

- Fixed FluidRigidBody having incorrect volume if the rigidbody was rotated on load.
- Correct default setting when creating Fluid Simulation through context menu. Previously default settings were not always set.
- All Fluid Simulation resources are now freed as opposed to only some.
- Broken links in documentation.

## [1.0.2] - 2024-07-09

### Added

- Custom TerraformTerrain Inspector with tooltips.
- Custom TerraformTerrain ShaderGUI for TerraformTerrain shaders.

### Changed

- Improved default values for second fluid layer settings. Matches lava better.
- Menu item values so that Fluid Frenzy appears with the rest of the GameObjects in the list.

### Fixed

- ComputeShader enableRandomWrite not set error when using second layer and modifying a parameter in settings at runtime.
- Runtime Generated HeatLUT now gets applied again after breaking in version 1.0.1.

## [1.0.1] - 2024-07-08

### Added

- GameObject/FluidFrenzy/Terraform Terrain context menu item to easily add a Terraform Terrain.

### Changed

- Improved default values for Fluid Foam Settings.
- Improved default values of the Water Shader. Defaults to no planar reflections and no vertex displacement.
- Copy material parameters assigned to the Fluid Surface to cloned material for rendering. This allows for easier tweaking and updating the material.
- Documentation improvements on how to install the package and sample scenes.

### Fixed

- Don't allow negative values in Fluid Simulation Settings fields: CellSize, Gravity, Acceleration.
- Only reset border pixels when disabling "Open Borders" in Fluid Simulation Settings. This prevents the simulation stalling when changing parameters.
- Unity 6 preview warnings. RigidBody.velocity is deprecated and should now be RigidBody.linearVelocity in Unity 6.

## [1.0.0] - 2024-05-05

### Added

- Release Fluid Frenzy.
