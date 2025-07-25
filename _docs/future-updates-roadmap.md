---
title: Future Updates & Roadmap
permalink: /docs/future_updates_roadmap/
---


These are some future features that are planned to be supported in Fluid Frenzy.

- **Performance optimizations:** Continuously work on improving the performance of the simulation and rendering to allow for larger and more complex fluid simulations without sacrificing speed.
- **Custom shader support:** Enable developers to create and implement custom shaders for the fluid simulation and rendering, providing more options for visual effects.
- **Tiled Simulations:** [Beta feature added in v1.0.6](#8-tiled-simulations-beta) Allow neighboring simulations to interact with each other. The purpose of tiled simulations is to create bigger simulation areas where simulations that are too far away can be disabled. 
- **Simulation Regions/Domains:** *Feature added in v1.2.1*
Allow only parts of the terrain to interact with the simulation, creating smaller simulations within a terrain instead of the full terrain being used by automatically grabbing the correct area of the source terrains.
- **HDRP Support:** Beta support for HDRP haas been added in v1.2.8. Shaders for HDRP have been added and a special mode for using it with the [HDRP Water System](../fluid_rendering_components#hdrp-water-system)
- **Underwater Rendering:** Enable rendering features like underwater rendering when the player/camera goes below the water.