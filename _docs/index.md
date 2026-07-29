---
title: About Fluid Frenzy
permalink: /docs/index/
redirect_from: /docs/index.html
---


Fluid Frenzy is an interactive GPU-accelerated fluid simulation and renderer designed specifically for use with Unity Terrain and Custom terrains. This project aims to provide developers with a powerful toolset to create realistic, fun, interactive and immersive fluid dynamics in their Unity projects.

<a name="key-features"></a>
### Key Features

- Real-time fluid simulation: Utilizing GPU acceleration for fast and interactive fluids.
- Seamless integration with Unity Terrain: Easily add fluid elements to your Unity Terrain for a more immersive environment.
- Custom terrain support: Compatible with custom terrains to give developers more flexibility in their projects.
- Advanced rendering capabilities: Create stunning visual effects with the built-in renderer and Universal Render Pipeline.
- Multiple fluid layers: Create complex interactions between different types of fluids, such as water and lava, that can mix and solidify into terrain surfaces like rock.
- Terrain erosion: Simulate erosion effects on terrain surfaces as fluids flow over them, creating realistic effects over time.
- Dynamic object interaction: Objects in the fluid can interact realistically, with buoyancy effects and advection as they move through the fluid simulation.
- Fluid modifiers: Customize the behavior of the fluid simulation with modifiers like waves, pressure fields, and whirlpools to create dynamic and visually interesting effects in your project.
- Universal Render Pipeline: Supports Universal Render Pipeline with minimal extra setup as all features, components, and shaders are useable in both Built-in and URP.

<a name="contents"></a>
### Contents

1. Fluid Simulation Scripts & Resources
    ```Runtime\Simulation```
2. Fluid Rendering Scripts & Resources
    ```Runtime\Rendering```
3. <a name="keyfeatures-samples">Sample Scenes</a>
    1. River ```Samples~\River\River.unity```
    2. RiverFlow ```Samples~\River\RiverFlow.unity```
    3. Grand Canyon (HDRP) ```Samples~\HDRP_GrandCanyon\HDRP_GrandCanyon.unity```
    4. Water Modifiers ```Samples~\WaterModifiers\WaterModifiers.unity```
    5. Volcano ```Samples~\Volcano\Volcano.unity```
    6. Terraform ```Samples~\Terraform\Terraform.unity```
    7. TerraformFlow ```Samples~\Terraform\TerraformFlow.unity```
    8. TerraformFlow Beams ```Samples~\Terraform\TerraformFlowBeams.unity```
    9. FossilFinder ```Samples~\FossilFinder\FossilFinder.unity```
    10. Pool ```Samples~\Pool\Pool.unity```
    11. GPULODTerrain ```Samples~\GPULODTerrain\GPULODTerrain.unity```
4. Documentation
    ```DOCUMENTATION.pdf```
    ```DOCUMENTATION.html```
    ```Documentation~\DOCUMENTATION.md```

<a name="requirements"></a>
### Requirements

| Hardware/Software | Version |
| ---- | ---- |
| Unity | 2021.3 or newer |
| OS | Windows 10 or newer |
| GPU | Nvidia GTX 1050 equivalent or higher |
| Graphics API | DirectX 11. DirectX 12. Vulkan. WebGL 2(Beta). |
| Shader Model | Recommended: 5.0. Minimum: 3.0 |
| Renderpipeline | Built-in. Universal Render Pipeline |

<a name="limitations"></a>
### Limitations

- Fluid Frenzy is a [2.5D/*Shallow Water Equation*](https://en.wikipedia.org/wiki/Shallow_water_equations) fluid simulation that is achieved by storing the height of the fluid in a 2D texture (X, Z). This method restricts the simulation to having only one height per pixel, thereby preventing the fluid from flowing both under and over objects simultaneously.
- The fluid simulation has a maximum speed limit determined by the 2.5D implementation used. In this simulation, the fluid is represented in a 2D texture where each pixel corresponds to a specific size in the world. The fluid can only move one pixel per step, resulting in a maximum speed limit based on the pixel's world units per frame. The simulation attempts to adjust automatically when the dimensions are scaled, but there is a limit to how fast or slow the fluid can move.
- Multiplayer is not supported in Fluid Frenzy since syncing the data over the network takes too much bandwidth and there is no guarantee simulations run in sync and stay in sync due to latency.
- Fluid Frenzy's WebGL 2 support is currently in beta. There is the possibility of bugs when running in WebGL 2. Please report them if you encounter them.
- WebGL 2 does not support compute shaders. Any feature that depends on compute is unavailable on WebGL and other platforms without compute support. See [Feature Support](#feature-support) for the full list and recommended alternatives. WebGPU may restore compute support in the future, but Unity support is still experimental and unstable with Fluid Frenzy.
- Older Unity versions below Unity 2021.3 are not officially supported. Unity 2020.3 is functional as of 01-04-2025 but may not have feature parity and constant support. Support may be added on request depending on the amount of work.

<a name="pipeline-support"></a>
### Pipeline Support

Fluid Frenzy supports all pipelines. Please refer to the table below for each version and the corresponding supported pipeline features. There are some differences between pipelines; for example, HDRP recommends using ShaderGraph to create shaders instead of writing custom shaders.

As a result, all shaders have HDRP-specific versions created in ShaderGraph, which should be used in place of custom shaders. The exception is the FluidFrenzy/Water shader, which remains a custom shader. To minimize compatibility issues across different Unity versions, support is limited to Unity 6000.0 and above for HDRP.

| Unity Version | Built-in Render Pipeline | Universal Render Pipeline | High Definition Render Pipeline |
|----------------|--------------------------|---------------------------|---------------------------------|
| 2021.3         | ✅ **<span style="color:green;">Supported</span>** | ✅ **<span style="color:green;">Supported</span>** | ❌ **<span style="color:red;">Not Supported</span>** |
| 2022.3         | ✅ **<span style="color:green;">Supported</span>** | ✅ **<span style="color:green;">Supported</span>** | ❌ **<span style="color:red;">Not Supported</span>** |
| 6000.0         | ✅ **<span style="color:green;">Supported</span>** | ✅ **<span style="color:green;">Supported</span>** | 🟠 **<span style="color:orange;">Beta</span>** |
| 6000.1         | ✅ **<span style="color:green;">Supported</span>** | ✅ **<span style="color:green;">Supported</span>** | 🟠 **<span style="color:orange;">Beta</span>** |

<a name="platform-support"></a>
### Platform Support

| Platform        | State       | Comments                                                |
|-----------------|-----------------|---------------------------------------------------------|
| Windows         | **<span style="color:green;">Supported</span>**             | Fully supported.                                       |
| macOS           | **<span style="color:red;">Unknown</span>**           | Untested, no device to develop or test                |
| Linux           | **<span style="color:green;">Supported</span>**             | Supported through Vulkan                              |
| Android         | **<span style="color:green;">Supported</span>**             | Supported, performance varies per device              |
| iOS             | **<span style="color:red;">Unknown</span>**           | Untested, no device to develop or test                |
| WebGL           | **<span style="color:orange;">Partial</span>**   | Core simulation and standard surface rendering work. Compute-dependent features are not supported — see [Feature Support](#feature-support). |
| WebGPU          | **<span style="color:orange;">Experimental</span>**   | Experimental due to Unity bugs                        |
| VR              | **<span style="color:green;">Supported</span>**             | Tested on Quest 1, performance varies per device     |

<a name="feature-support"></a>
### Feature Support

Fluid Frenzy's core shallow-water simulation and standard mesh surface rendering use GPU fragment shaders and run on WebGL 2 and other platforms without compute shaders.

Several optional features rely on **compute shaders**. Those features are **not available** when `SystemInfo.supportsComputeShaders` is false — most notably **WebGL 2**, which has no compute shader support in Unity.

| Feature | Requires compute | Without compute | Alternative |
| --- | --- | --- | --- |
| [Fluid World Renderer](../fluid_rendering_components#fluid-world-renderer) | Yes | **Not supported** | Use a [Fluid Renderer](../fluid_rendering_components#fluid-renderer) per simulation tile with **MeshRenderer** or **DrawMesh** render mode. |
| **GPULOD** surface render mode ([Fluid Renderer](../fluid_rendering_components#fluid-renderer)) | Yes | **Not supported** (falls back to MeshRenderer) | Use **MeshRenderer** or **DrawMesh** explicitly. |
| [Fluid Particle Generator](#fluid-particle-generator) (splash, spray, foam) | Yes | **Not supported** | Disable the layer or omit particle effects. |
| GPU particles on [Terraform Layer](../fluid_simulation_components#terraform-layer) (e.g. steam when fluids mix) | Yes | **Not supported** | Fluid mixing and terrain conversion still work; only the steam VFX is omitted. |
| [FFT ocean](../fluid_rendering_components#fft-generator-settings) / JONSWAP detail waves | Yes | **Not supported** | Use **Gerstner** dynamic waves or a **baked flipbook** in [Detail Wave Settings](../fluid_rendering_components#detail-wave-settings). |
| [Fluid Rigidbody](../fluid_simulation_components#fluid-rigidbody) (two-way coupling) | Yes | **Not supported** | Use [Fluid Rigidbody Lite](../fluid_simulation_components#fluid-rigidbody-lite) for simplified buoyancy and impact splashes. |
| GPU buoyancy sampling with [Fluid World Renderer](../fluid_rendering_components#fluid-world-renderer) | Yes | **Not supported** | Use per-tile [Fluid Renderer](../fluid_rendering_components#fluid-renderer) and enable **CPU Height Read** (`readBackHeight`) on each [Fluid Simulation](../fluid_simulation_components#fluid-simulation). |
| GPULOD Terrain sample | Yes | **Not supported** | Use Unity Terrain, [Simple Terrain](../terrain#simple-terrain), or another non-GPULOD terrain. |

**Generally supported without compute:** [Flux](../fluid_simulation_components#flux-fluid-simulation) and [Flow](../fluid_simulation_components#flow-fluid-simulation) fluid simulation, [Foam Layer](../fluid_simulation_components#foam-layer), [Flow Mapping](../fluid_simulation_components#flowmapping), [Erosion Layer](../fluid_simulation_components#erosion-layer), terraform mixing (without steam particles), [Fluid Modifiers](../terrain#fluid-modifier), [Fluid Simulation Obstacle](../fluid_simulation_components#fluid-simulation-obstacle), standard water/lava rendering, and [Fluid Rigidbody Lite](../fluid_simulation_components#fluid-rigidbody-lite).

**Related platform limits (not compute):** [Fluid Simulation Obstacle](../fluid_simulation_components#fluid-simulation-obstacle) **Conservative Rasterization** requires hardware support and is unavailable on WebGL, OpenGL ES, and some older mobile GPUs (the system falls back to standard rasterization automatically).

<a name="installation"></a>
