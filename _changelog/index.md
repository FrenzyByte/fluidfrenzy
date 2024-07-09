---
title: Changelog
permalink: /changelog/index/
redirect_from: /changelog/index.html
---

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
