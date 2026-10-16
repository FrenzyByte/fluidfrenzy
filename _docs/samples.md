---
title: Samples
permalink: /docs/samples/
---


**Important Info! To prevent project bloat the samples are not imported into your Assets folder by default. Follow the instructions below to import them.**

Fluid Frenzy contains several sample scenes to showcase the functionality and help with understanding how to work with the fluid simulation. You can import the samples using the *Package Manager*. 

<a name="samples-import"></a>
### Importing Samples

1. Open the ```Package Manager```.
<br>![Package Manager Open](../../assets/images/packagemanager_open.png)<br>
2. Select ```In Project```.
3. Select ```Fluid Frenzy``` in the list under **```Packages - Frenzy Byte```**.
4. Go to the ```Samples``` tab.
5. Click the ```Import``` button.
<br>![Package Manager Import Scenes](../../assets/images/packagemanager_importscenes.png)<br>

<a name="samples-pipelines"></a>
### Universal Render Pipeline

All samples withing the package are designed for the Built-in Render Pipeline but are functional with all Render Pipelines. 
When opening the samples with the Universal or High-Definition Render Pipeline active the sample materials are automatically upgraded when opening the sample scene.

<a name="samples-running"></a>
### Running Samples

To run the samples, open any of the scenes in the ```Assets/Samples/Fluid Frenzy/2.0.8/Samples``` folder and click play. Scenes can be loaded at run-time in the **Scenes** tab in the UI. There are several options in the UI *Input Tab* to select from. Control the fluid input type, fluid rigid body spawning, boat driving and "FlyCam". 

![Samples UI](../../assets/images/samples_ui.png)

*Note: The samples optionally use the [Unity Post-Processing package](https://docs.unity3d.com/Packages/com.unity.postprocessing@3.4/manual/Installation.html) for higher-quality visuals. It will be automatically enabled if the Post-Processing package is imported into the project.*  

<a name="samples-controls"></a>
Controls

All samples are designed to be compatible with both the Unity Input System package and the Legacy Input Manager. The system automatically checks for the presence of the new Input System package at runtime and uses it if available; otherwise, it defaults to the Legacy Input Manager. This ensures the controls below function regardless of your project's input configuration.

- F1 - select the Fly Cam to fly around the scene using the 'WASD' keys and mouse.
- F2 - select the Offset Cam which follows around the Player Boat.
- F3 - select the Third Person Cam which follows around the Player Boat.
- F4 - select the Smooth Third Person Cam which follows around the Player Boat.
-  F5 - select the Orbit Cam which orbits around the Player Boat and can be controlled with the mouse.
- F6 - enables the RTS Cam which can be used to pan over the scene using the 'WASD' keys.
- 1-9 - select the simulation input mode depending on the scene loaded. 1 Is always water.
- 'WASD' - controls the Fly Cam, RTS Cam, and the Player Boat, allowing you to move forward.
- Arrows - rotates the Fly Cam and RTS Cam.
- Mouse Left - when held rotates Fly Cam and RTS Cam when moving the mouse.
- Mouse Right - when held adds the selected fluid/terrain to the simulation at the mouse location.

<a name="samples-river"></a>
### River

![River Sample](../../assets/images/sample_river.png)

The River sample shows the use of [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) adding water from multiple sources to create three river branches. The camera starts at the end of one of these branches with a boat that can be driven across the scene. Water flows out of the scene due to the *Open Borders* functionality of the fluid simulation to prevent flooding of the scene. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

An alternative scene, **RiverFlow**, is also available and utilizes the `FlowFluidSimulation` instead of the default `FluxFluidSimulation`. The `FlowFluidSimulation` is an alternative fluid dynamics model that may offer different performance characteristics and simulation behavior compared to the `FluxFluidSimulation`.

A third variant, **MultiFluid RiverFlow**, uses two fluid layers so water and lava can share the same river.

<div style="page-break-after: always;"></div>

<a name="samples-grandcanyon"></a>
### Grand Canyon

![Grand Canyon (HDRP) Sample](../../assets/images/sample_grandcanyon.png)

The Grand Canyon (HDRP) sample demonstrates the [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) adding water from multiple sources to fill the canyon below. Built specifically for HDRP, this scene showcases fluid interaction with HDRP-native lighting, sky, and fog. It features a drivable boat and utilizes Unity Terrain. Because it uses standard Unity Terrain, modifying the landscape in real-time is not supported.

<a name="samples-watermodifiers"></a>
### Water Modifiers

![Water Modifiers Sample](../../assets/images/sample_watermodifiers.png)

The Water Modifiers sample shows the use of [Fluid Modifier Waves](../fluid_modifiers#fluid-modifier-waves) to create different types of waves, [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) to create a vortex, and [Fluid Rigidbody](../fluid_simulation_components#fluid-rigidbody) showcasing buoyancy and advection of objects. The camera starts overlooking the vortex, you can add water and spawn [Fluid Rigid Bodies](../fluid_simulation_components#fluid-rigidbody) using the mouse. 

<a name="samples-volcano"></a>
### Volcano

![Volcano Sample](../../assets/images/sample_volcano.png)

The Volcano scene showcases that different fluids can be rendered like lava. This scene uses the [Lava Surface](../fluid_rendering_components#lava) [Fluid Renderer](../fluid_simulation_components#fluid-rendering-components) to create an erupting volcano. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

<a name="samples-terraform"></a>
### Terraform

![Terraform Sample](../../assets/images/sample_terraform.png)

The Terraform scene showcases God Game simulation with two types of fluid interacting with each other and erosion of the top sand layer. Water and Lava are automatically added to the scene from different locations and when they touch they turn into rocky terrain and steam. Fluid and Terrain can be added using the mouse input as described in the controls section. This scene makes use of a custom terrain allowing modifications to be made to it in real-time by adding erodible sand, or non-erodible rock and vegetation.

An alternative scene, **TerraformFlow**, utilizes the `FlowFluidSimulation` instead of the default `FluxFluidSimulation`. This model offers different performance characteristics and simulation behavior for its fluid dynamics.

A third variant, **TerraformFlow Beams**, allows you to shoot energy beams to terraform the landscape. These beams can melt snow and rock into water and lava, or freeze lava and water back into rock and snow.

<a name="samples-fossilfinder"></a>
### Fossil Finder

![FossilFinder Sample](../../assets/images/sample_fossilfinder.png)

The **FossilFinder** scene demonstrates erodible terrain mechanics featuring a dinosaur fossil buried beneath a thick layer of sand. By using the [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) to pour water onto the landscape, the sand is washed away to reveal the hidden remains. This scene utilizes the custom terrain system to allow for real-time erosion and sediment displacement as the water interacts with the surface.

<a name="samples-pool"></a>
### Pool

![Pool Sample](../../assets/images/sample_pool.png)

The Pool sample demonstrates the Layers capture method, which uses a top-down orthographic capture to allow the fluid to interact with specific GameObject layers. This scene features advanced visual effects like underwater rendering and caustics, alongside Solid <---> Fluid interaction including buoyancy and ripples. It also includes a [Fluid Event Trigger](../fluid_simulation_components#fluid-simulation-event) example. An object in this scene turns red when it enters the water. See [Layer Capture Simulation](../setup#setup-layer-capture) if you want to use this capture method in your own scene.

<a name="samples-simpleterraform"></a>
### Simple Terraform

![Terraform Sample](../../assets/images/sample_terraform.png)

The Simple Terraform scene offers a minimal version of the full Terraform simulation, focusing on ease of use and script readability. Unlike the main samples (like **Terraform**), where available fluids and terrain layers are dynamically generated at runtime from a centralized [Scene Configuration](#scene-configuration) file, this scene utilizes a simpler setup where the UI buttons for adding materials (e.g., Water, Lava, Sand) are fixed and hardcoded within the scene's scripts. This design is intended for users who wish to quickly copy and integrate the core terraforming logic into their own scenes without relying on the dynamic configuration system.

*Note: The scripts, scene and UI components in this sample are setup with specific type of terrain layers and fluids. If you wish to reuse the scripts make sure your scene is setup the same or modify your layers accordingly.*

<a name="samples-tiledsimulation"></a>
### Tiled Simulation

Demonstrates multiple simulations that neighbour each other on different **Terrain** tiles interacting with each other. In this sample fluid from each tile can flow into it's neighbouring tile. Allowing the creation of larger and non-square scenes.
More information can be found [here](../using_shadergraph#tiled-simulation).

For a large ocean surface drawn as one mesh, see the [World](#samples-world) sample.

<a name="samples-world"></a>
### World

![World Sample](../../assets/images/sample_world.png)

The World sample shows how to render a large body of water with a [Water World Renderer](../fluid_rendering_components#water-world-renderer) instead of a per-tile [Water Surface](../fluid_rendering_components#water-surface). A [Flow Fluid Simulation](../fluid_simulation_components#flow-fluid-simulation) covers the Unity Terrain coastline. Four [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) sources feed rivers into that simulation. The world renderer draws a much larger GPULOD surface around it, with ocean FFT swell, detail waves, underwater rendering, caustics, wet lens, and screen-space reflections.

The local simulation is coupled to the ocean FFT so the shallow water on the coast follows the swell. Open borders hold a rest surface level so water can leave the terrain tile without flooding it. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

This is a different setup from the [Tiled Simulation](#samples-tiledsimulation) sample. Tiled Simulation is about neighbouring simulation tiles exchanging fluid. World is about drawing a simulation inside one large ocean surface. See [Fluid World Renderer](../fluid_rendering_components#fluid-world-renderer) if you want to set this up in your own scene.

<a name="samples-runtimesetup"></a>
### Runtime Setup

Demonstrates how to setup a fluid simulation at runtime with `FluidSimulation.Create` and `LavaSurface.Create`. This can be useful for when a game makes use of procedurally generated terrain that does not exist before entering playmode. See [Creating simulations, modifiers, and obstacles](../c_interaction_scripting#creating-simulations-modifiers-obstacles).

<a name="samples-statesync"></a>
### State Sync

Two Flow simulations already sit in the scene. Left is the host. Right is the joiner. This is a local demo of the multiplayer pattern. It is not a networked session. Hold the mouse to pour. Pours are applied to both basins in local space. Press C to copy a solver snapshot from host to joiner. Press R to reset the joiner, then C again to see a late join. Press T to pour on only one basin so they drift. Foam will not match. You still pick the network library. See [Multiplayer Support (Beta)](../third_party_support#multiplayer-support).

<a name="samples-gpulodterrain"></a>
### GPULOD Terrain

![GPULOD Terrain Sample](../../assets/images/sample_gpulodterrain.png)

The GPULODTerrain sample showcases a custom GPU Quadtree terrain system designed to work seamlessly with the fluid and terraform systems. It provides a simple, extensible foundation for users who want to build their own terrain solutions on top of the simulation. This scene demonstrates how the GPU-driven geometry is used for Terrains.

<a name="scene-configuration"></a>
### Scene Configuration

The `SceneConfiguration` is a central **Scriptable Object** asset used across many of the provided samples (such as **River**, **Grand Canyon**, and **Terraform**) to define the available fluids and terrain materials for a scene.

This approach decouples the UI and simulation setup from the core scene logic. A typical `SceneConfiguration` asset includes lists of:
*   Fluid materials (e.g., Water, Lava).
*   Terrain layers (e.g., Erodible Sand, Non-Erodible Rock, Vegetation).

At runtime, sample scenes load this configuration to dynamically generate UI elements (like buttons for adding fluid or terrain materials). This system allows developers to easily modify the types of fluids and terrain available in a scene without needing to change the underlying scene code or scripts. The **Simple Terraform** scene is the primary exception, as it uses a fixed setup for simplicity.

<div style="page-break-after: always;"></div>

<a name="setup"></a>
