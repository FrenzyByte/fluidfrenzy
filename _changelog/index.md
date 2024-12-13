---
title: Changelog
permalink: /changelog/index/
redirect_from: /changelog/index.html
---

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
- Rendering: Normalize the TerraformTerrain splatmap sampling to prevent weights higher than oen when layers are on top of each other.
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

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
