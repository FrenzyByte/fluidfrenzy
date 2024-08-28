---
title: Changelog
permalink: /changelog/index/
redirect_from: /changelog/index.html
---

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
