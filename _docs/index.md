---
title: About Fluid Frenzy
permalink: /docs/index/
redirect_from: /docs/index.html
---

* this unordered seed list will be replaced by toc as unordered list
{:toc}

Fluid Frenzy is an interactive GPU-accelerated fluid simulation and renderer designed specifically for use with Unity Terrain and Custom terrains. This project aims to provide developers with a powerful toolset to create realistic, fun, interactive and immersive fluid dynamics in their Unity projects.

<a name="key-features"></a>
### Key Features

- Real-time fluid simulation: Utilizing GPU acceleration for fast and interactive fluids.
- Seamless integration with Unity Terrain: Easily add fluid elements to your Unity Terrain for a more immersive environment.
- Custom terrain support: Compatible with custom terrains to give developers more flexibility in their projects.
- Advanced rendering capabilities: Create stunning visual effects with the built-in renderer.
- Multiple fluid layers: Create complex interactions between different types of fluids, such as water and lava, that can mix and solidify into terrain surfaces like rock.
- Terrain erosion: Simulate erosion effects on terrain surfaces as fluids flow over them, creating realistic effects over time.
- Dynamic object interaction: Objects in the fluid can interact realistically, with buoyancy effects and advection as they move through the fluid simulation.
- Fluid modifiers: Customize the behavior of the fluid simulation with modifiers like waves, pressure fields, and whirlpools to create dynamic and visually interesting effects in your project.

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

<a name="installation"></a>
### Installation

- Add the package through *Assets > Import Package > Custom Package*.
- Select the *.unitypackage* file for Fluid Frenzy. This will add the package to the *Package Manager*

<a name="requirements"></a>
### Requirements

| Hardware/Software | Version |
| ---- | ---- |
| Unity | 2021.3 or newer |
| OS | Windows 10 or newer |
| GPU | Nvidia GTX 1050 equivalent or higher |
| Graphics API | DirectX 11. DirectX 12. Vulkan |
| Shader Model | Recommended: 5.0. Minimum: 3.0 |

<a name="limitations"></a>
### Limitations

- Fluid Frenzy is a [2.5D/*Shallow Water Equation*](https://en.wikipedia.org/wiki/Shallow_water_equations) fluid simulation that is achieved by storing the height of the fluid in a 2D texture (X, Z). This method restricts the simulation to having only one height per pixel, thereby preventing the fluid from flowing both under and over objects simultaneously.
- The fluid simulation has a maximum speed limit determined by the 2.5D implementation used. In this simulation, the fluid is represented in a 2D texture where each pixel corresponds to a specific size in the world. The fluid can only move one pixel per step, resulting in a maximum speed limit based on the pixel's world units per frame. The simulation attempts to adjust automatically when the dimensions are scaled, but there is a limit to how fast or slow the fluid can move.
- Multiplayer is not supported in Fluid Frenzy since syncing the data over the network takes too much bandwidth and there is no guarantee simulations run in sync and stay in sync due to latency.

<a name="samples"></a>
### Samples

Fluid Frenzy contains five sample scenes to showcase the functionality and help with understanding how to work with the fluid simulation. You can import the samples using the *Package Manager*. To run the samples, open any of the scenes in the [Samples~](#keyfeatures-samples) folder and click play. Scenes can be loaded at run-time in the **Scenes** tab in the UI. There are several options in the UI *Input Tab* to select from. Control the fluid input type, fluid rigid body spawning, boat driving and "FlyCam". 

![Samples UI](../../assets/images/samples_ui.png)

*Note: The samples optionally use the [Unity Post-Processing package](#https://docs.unity3d.com/Packages/com.unity.postprocessing@3.4/manual/Installation.html) for higher-quality visuals. It will be automatically enabled if the Post-Processing package is imported into the project.*  

#### Controls

- F1 - select the *Fly Cam* to fly around the scene using the *'WASD'* keys and mouse.
- F2 - select the *Offset Cam* which follows around the *Player Boat*.
- F3 - select the *Third Person Cam* which follows around the *Player Boat*.
- F4 - select the *Smooth Third Person Cam* which follows around the *Player Boat*.
- F5 - select the *Orbit Cam* which orbits around the *Player Boat* and can be controlled with the mouse.
- F6 - enables the *RTS Cam* which can be used to pan over the scene using the *'WASD'* keys.
- 1-5 - select the simulation input mode depending on the scene loaded. 1 Is always water.
- 'WASD' - controls the *Fly Cam*, *RTS Cam*, and the *Player Boat*, allowing you to move forward.
- Arrows - rotates the *Fly Cam* and *RTS Cam*.
- Mouse Left - when held rotates *Fly Cam* and *RTS Cam* when moving the mouse.
- Mouse Right - when held adds the selected fluid/terrain to the simulation at the mouse location.

#### River

![River Sample](../../assets/images/sample_river.png)

The River sample shows the use of [Fluid Modifier Volume](#fluid-modifier-volume) adding water from multiple sources to create three river branches. The camera starts at the end of one of these branches with a boat that can be driven across the scene. Water flows out of the scene due to the *Open Borders* functionality of the fluid simulation to prevent flooding of the scene. This scene makes use of the Unity Terrain so modifying the terrain in realtime- is not possible.

<div style="page-break-after: always;"></div>

#### Grand Canyon

![Grand Canyon Sample](../../assets/images/sample_grandcanyon.png)

The Grand Canyon sample shows the use of [Fluid Modifier Volume](#fluid-modifier-volume) adding water from multiple sources on top of the canyon filling the canyon below. The camera starts a boat that can be driven across the scene. Water stays in the scene due to the *Open Borders* functionality of the fluid simulation being disabled causing the scene to eventually flood. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

#### Water Modifiers

![Water Modifiers Sample](../../assets/images/sample_watermodifiers.png)

The Water Modifiers sample shows the use of [Fluid Modifier Waves](#fluid-modifier-waves) to create different types of waves, [Fluid Modifier Volume](#fluid-modifier-volume) to create a vortex, and [Fluid Rigidbody](#fluid-rigidbody) showcasing buoyancy and advection of objects. The camera starts overlooking the vortex, you can add water and spawn [Fluid Rigid Bodies](#fluid-rigidbody) using the mouse. 

#### Volcano

![Volcano Sample](../../assets/images/sample_volcano.png)

The Volcano scene showcases that different fluids can be rendered like lava. This scene uses the [Lava Surface](#lava) [Fluid Renderer](#fluid-rendering-components) to create an erupting volcano. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

#### Terraform

![Terraform Sample](../../assets/images/sample_terraform.png)

The Terraform scene showcases God Game simulation with two types of fluid interacting with each other and erosion of the top sand layer. Water and Lava are automatically added to the scene from different locations and when they touch they turn into rocky terrain and steam. Fluid and Terrain can be added using the mouse input as described in the controls section. This scene makes use of a custom terrain allowing modifications to be made to it in real-time by adding erodible sand, or non-erodible rock and vegetation.

---

<div style="page-break-after: always;"></div>

<a name="setup"></a>
