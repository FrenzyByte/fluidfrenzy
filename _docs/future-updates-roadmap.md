---
title: Future Updates & Roadmap
permalink: /docs/future_updates_roadmap/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

### Fluid Frenzy: 2026 Development Roadmap

The vision for 2026 is to push Fluid Frenzy beyond a standalone simulation and into a fully integrated environment fluid rendering system. Following the 1.4.0 release. I am shifting focus toward high-end rendering features and creating the fluid renderpipeline system where I create shared effects across all pipelines. 

These dates are based on when I believe implement these features but some may be sooner or later depending on what comes up. They may also be re-prioritized based on requests of users.

#### Roadmap Overview

| Status | Feature | Target | Description |
| :--- | :--- | :--- | :--- |
| 🟢&nbsp;**Implemented** | **Dynamic Light Caustics** | February 2026 | Project real-time light patterns onto the ground based on the surface waves of the fluid simulation. |
| 🟡&nbsp;**Active** | **Aquarium Mode** | February 2026 | Support for side viewing of the water surface. |
| 🟠&nbsp;**Planned** | **Hybrid Ocean System** | March 2026 | Integration of Gerstner or FFT wave math into the simulation for large open water visuals. |
| 🟠&nbsp;**Planned** | **Volumetric Fluid Lighting** | April 2026 | Underwater god rays that react to surface turbulence and provide depth-based light scattering. |
| 🟠&nbsp;**Planned** | **GPU Clipmaps** | April 2026 | Optimization system using nested grids to simulate massive areas with high-detail localized around the camera. |
| 🟠&nbsp;**Planned** | **Custom SSR** | May 2026 | A dedicated Screen Space Reflection implementation for the water shader to provide high-quality reflections in URP. |
| 🟠&nbsp;**Planned** | **Stylized & Toon Shaders** | June 2026 | Dedicated shaders for stylized looks, cel-shading, ink-outlines, and procedural toon foam patterns. |
| 🟠&nbsp;**Planned** | **Surface Decals & Velocity Helper** | June 2026 | Render floating debris like lilypads that naturally follow the simulation's velocity field. |
| 🟠&nbsp;**Planned** | **Dynamic Wetness Maps** | July 2026 | Global shader support to allow shoreline objects and terrain to appear wet and reflective based on disappearing fluids. |
| 🟠&nbsp;**Planned** | **Dynamic Lens Wetness** | July 2026 | A post-process effect simulating droplets and wiping streaks on the camera lens after emerging from the fluid. |
| 🟠&nbsp;**Planned** | **Subsurface Bubbles** | August 2026 | GPU-accelerated particles representing bubbles that spawn in turbulent areas and swirl with the flow. |
| 🔴&nbsp;**Future** | **Editor-Time Simulation** | September 2026 | Support for running the simulation directly in the Scene View to preview behavior and erosion while designing levels. |
| 🔴&nbsp;**Future** | **Terraform Sculpting Tools** | October 2026 | Manual sculpting brushes to carve and shape the Terraform Terrain system directly in the editor. |
| 🔴&nbsp;**Future** | **Localized Moving Ripples** | November 2026 | High-detail ripples that follow the player for fine grained interaction that advects with the main flow. |
| 🔎&nbsp;**Research** | **Surface <> Particle Blending** | December 2026 | Secret tech. |
| 🔎&nbsp;**Research** | **Simulation Baking (VATs)** | 2027 | Export simulations into Vertex Animation Textures for high-performance playback on mobile assets. |
| 🔎&nbsp;**Research** | **Unity Terrain Terraforming** | 2027+ | Support for the native Unity Terrain system to be permanently eroded and terraformed by the fluid simulation. |

#### Upcoming Feature Breakdown

**Dynamic Light Caustics**
I am finishing up a system that allows you to project light patterns onto the terrain and objects beneath the fluid. It samples the fluid simulation data and projects textures and waves based on the depth, velocity and surface normals, creating sharp dancing patterns that move in sync with the waves.

**Aquarium Mode**
This mode is specifically for side-on viewing. I am adding support for the fluid profile, ensuring that when you look at the fluid from the side you still see water.

**Hybrid Ocean System**
I am integrating Gerstner or FFT wave functions into the existing simulation. This allows for deep-sea visuals on a massive scale. The waves aren't just visual, I plan to make them work with the shallow water equations so that waves that go over terrain will leave water to flow away naturally.

**Volumetric Fluid Lighting**
I want to enhance the underwater experience by adding volumetric light shafts. These rays shimmer and break apart as they pass through the surface waves, creating a realistic god ray effect that reacts to the fluid's motion.

**GPU Clipmaps**
To support larger environments, I am implementing a new surface rendering system that will allow multiple simulations to be in one rendering surface. This ensures the simulation is always highest resolution near the camera. As you move, the detail follows you, while distant fluid is simulated at a lower frequency to save performance. Currently there is already the GPU-LOD system but this system is not as good for streaming in simulation data like clipmaps are. Some research needs to be done to see what is possible and if this is viable.

**Custom Screen Space Reflections (SSR)**
Since URP lacks a native SSR solution, I am building one directly into the Fluid Frenzy water surface. This will allow for high-quality, dynamic reflections of the scene geometry on the water surface without the heavy cost of rendering extra Planar Reflection cameras.

**Stylized & Toon Shaders**
I am adding a dedicated set of shaders for projects with an stylized or cartoon look. This includes cel-shading, ink outlines, and procedural toon-foam patterns that react to the simulation's movement.

**Surface Decals & Velocity Influence Helper**
The decal system allows you to stamp textures like lilypads directly onto the fluid surface. These decals move naturally with the flow of the water. I am also adding a Velocity Helper component to easily link external meshes to the simulation data so they can be pushed by currents, like seaweed.

**Dynamic Wetness Maps**
This feature provides a shader hook for your environment materials. When the fluid level rises and then recedes, the terrain and objects will appear darker and more reflective (wet) before gradually drying out over time, creating a more realistic shoreline.

**Dynamic Lens Wetness & Wipers**
I am developing a post-process effect that simulates a wet lens when the camera emerges from being submerged. I am also thinking about adding droplets that will form and run down the screen similar to  racing games where movement speed causes water to streak or wipers push them way on the windscreen of the car.

**Subsurface Bubbles**
To make high-velocity areas like waterfalls or boat wakes feel more realistic, I am adding a bubble system. These GPU particles are placed under the surface in turbulent zones, swirling underwater with the velocity field before rising to the surface.

**Editor-Time Simulation Preview**
This workflow improvement allows you to run the fluid simulation directly in the Unity Scene View without hitting the Play button. This makes it much easier to place obstacles, modifiers, and sources by seeing how the fluid reacts to your changes in real-time.

**Terraform Sculpting & Erosion Tools**
I am expanding the Terraform Terrain system with sculpting brushes. This will allow you to carve riverbeds or build up banks directly in the Scene View. 

**Localized Moving Ripples**
This system provides high-frequency micro-ripples that follow a specific target (like the player). This allows for very fine interaction detail around the player that still gets warped and pushed by the larger-scale river currents or waves.

**Surface <> Particle Blending**
Secret tech.

**Simulation Baking (VATs)**
For projects targeting low-end mobile devices or for background decorations, you can bake a complex simulation into a Vertex Animation Texture. This allows you to play back a pre-recorded simulation with virtually no CPU or GPU performance hit. This is highly experimental and may not be implemented.

**Native Unity Terrain Terraforming**
My long term goal is to bring the terraforming, erosion, and liquification features to the native Unity Terrain system. This will allow Fluid Frenzy to permanently modify and carve the standard Unity terrain at runtime. This might require the new Unity Terrain system if/when it comes out.

---

#### Old Roadmap

- **Custom shader support:** Enable developers to create and implement custom shaders for the fluid simulation and rendering, providing more options for visual effects. ***Feature added in v1.2.18***
- **Tiled Simulations:** Allow neighboring simulations to interact with each other. The purpose of tiled simulations is to create bigger simulation areas where simulations that are too far away can be disabled. ***Feature added in v1.0.6***
- **Simulation Regions/Domains:** 
Allow only parts of the terrain to interact with the simulation, creating smaller simulations within a terrain instead of the full terrain being used by automatically grabbing the correct area of the source terrains. ***Feature added in v1.2.1***
- **HDRP Support:** Beta support for HDRP haas been  Shaders for HDRP have been added and a special mode for using it with the [HDRP Water System](../fluid_rendering_components#hdrp-water-system). ***Feature added in v1.2.8.***
- **Underwater Rendering:** Enable rendering features like underwater rendering when the player/camera goes below the water. ***Feature added in v1.3.6***