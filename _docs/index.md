---
title: About Fluid Frenzy
permalink: /docs/index/
redirect_from: /docs/index.html
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
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
    2. Grand Canyon ```Samples~\GrandCanyon\GrandCanyon.unity```
    3. Water Modifiers ```Samples~\WaterModifiers\WaterModifiers.unity```
    4. Volcano ```Samples~\Volcano\Volcano.unity```
    5. Terraform ```Samples~\Terraform\Terraform.unity```
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
- WebGL 2 does not support Compute Shaders, for this reason, the GPU particle system used for steam when water/lava interact does not work on WebGL 2. In the future, WebGPU should support this but there are still some bugs within Unity that cause instability with Fluid Frenzy.
- Older Unity versions below Unity 2021.3 are not officially supported. Unity 2020.3 is functional as of 01-04-2025 but may not have feature parity and constant support. Support may be added on request depending on the amount of work.

<a name="pipeline-support"></a>
### Pipeline Support

Fluid Frenzy supports all pipelines. Please refer to the table below for each version and the corresponding supported pipeline features. There are some differences between pipelines; for example, HDRP recommends using ShaderGraph to create shaders instead of writing custom shaders.

As a result, all shaders have HDRP-specific versions created in ShaderGraph, which should be used in place of custom shaders. The exception is the FluidFrenzy/Water shader, which remains a custom shader. To minimize compatibility issues across different Unity versions, support is limited to Unity 6000.0 and above for HDRP.

| Unity Version | Built-in Render Pipeline | Universal Render Pipeline | High Definition Render Pipeline |
|----------------|--------------------------|---------------------------|---------------------------------|
| 2021.3         | **<span style="color:green;">Supported</span>** | **<span style="color:green;">Supported</span>** | **<span style="color:red;">Not Supported</span>** |
| 2022.3         | **<span style="color:green;">Supported</span>** | **<span style="color:green;">Supported</span>** | **<span style="color:red;">Not Supported</span>** |
| 6000.0         | **<span style="color:green;">Supported</span>** | **<span style="color:green;">Supported</span>** | **<span style="color:orange;">Beta</span>** |
| 6000.1         | **<span style="color:green;">Supported</span>** | **<span style="color:green;">Supported</span>** | **<span style="color:orange;">Beta</span>** |

<a name="platform-support"></a>
### Platform Support

| Platform        | State       | Comments                                                |
|-----------------|-----------------|---------------------------------------------------------|
| Windows         | **<span style="color:green;">Supported</span>**             | Fully supported.                                       |
| macOS           | **<span style="color:red;">Unknown</span>**           | Untested, no access to develop or test                |
| Linux           | **<span style="color:green;">Supported</span>**             | Supported through Vulkan                              |
| Android         | **<span style="color:green;">Supported</span>**             | Supported, performance varies per device              |
| iOS             | **<span style="color:red;">Unknown</span>**           | Untested, no access to develop or test                |
| WebGL           | **<span style="color:green;">Supported</span>**             | Supported, except GPU Particles (steam/splash)       |
| WebGPU          | **<span style="color:orange;">Experimental</span>**   | Experimental due to Unity bugs                        |
| VR              | **<span style="color:green;">Supported</span>**             | Tested on Quest 1, performance varies per device     |

<a name="installation"></a>
