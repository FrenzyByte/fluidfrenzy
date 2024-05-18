---
title: Welcome
permalink: /docs/home/
redirect_from: /docs/index.html
---

* this unordered seed list will be replaced by toc as unordered list
{:toc}

<div style="page-break-after: always;"></div>

<a name="about"></a>
## About Fluid Frenzy

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

![Samples UI](../../docs/images/samples_ui.png)

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

![River Sample](../../docs/images/sample_river.png)

The River sample shows the use of [Fluid Modifier Volume](#fluid-modifier-volume) adding water from multiple sources to create three river branches. The camera starts at the end of one of these branches with a boat that can be driven across the scene. Water flows out of the scene due to the *Open Borders* functionality of the fluid simulation to prevent flooding of the scene. This scene makes use of the Unity Terrain so modifying the terrain in realtime- is not possible.

<div style="page-break-after: always;"></div>

#### Grand Canyon

![Grand Canyon Sample](../../docs/images/sample_grandcanyon.png)

The Grand Canyon sample shows the use of [Fluid Modifier Volume](#fluid-modifier-volume) adding water from multiple sources on top of the canyon filling the canyon below. The camera starts a boat that can be driven across the scene. Water stays in the scene due to the *Open Borders* functionality of the fluid simulation being disabled causing the scene to eventually flood. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

#### Water Modifiers

![Water Modifiers Sample](../../docs/images/sample_watermodifiers.png)

The Water Modifiers sample shows the use of [Fluid Modifier Waves](#fluid-modifier-waves) to create different types of waves, [Fluid Modifier Volume](#fluid-modifier-volume) to create a vortex, and [Fluid Rigidbody](#fluid-rigidbody) showcasing buoyancy and advection of objects. The camera starts overlooking the vortex, you can add water and spawn [Fluid Rigid Bodies](#fluid-rigidbody) using the mouse. 

#### Volcano

![Volcano Sample](../../docs/images/sample_volcano.png)

The Volcano scene showcases that different fluids can be rendered like lava. This scene uses the [Lava Surface](#lava) [Fluid Renderer](#fluid-rendering-components) to create an erupting volcano. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

#### Terraform

![Terraform Sample](../../docs/images/sample_terraform.png)

The Terraform scene showcases God Game simulation with two types of fluid interacting with each other and erosion of the top sand layer. Water and Lava are automatically added to the scene from different locations and when they touch they turn into rocky terrain and steam. Fluid and Terrain can be added using the mouse input as described in the controls section. This scene makes use of a custom terrain allowing modifications to be made to it in real-time by adding erodible sand, or non-erodible rock and vegetation.

---

<div style="page-break-after: always;"></div>

<a name="setup"></a>
## Setup

Fluid Frenzy is easy and quick to set up ready for use with just a few clicks. To set up a scene to use Fluid Frenzy follow the steps below:

<a name="setup-water-simulation"></a>
### Water Simulation

These steps will describe how to set up a fluid simulation that will simulate and render water.

![Water Simulation Setup](../../docs/images/gameobject_fluidfrenzy_watersimulation.png)

1. *(Optional)* Select the Terrain you want to fluid simulation to interact with.
2. Add a [Fluid Simulation](#fluid-simulation) by clicking the GameObject menu and selecting *`Fluid Frenzy > Create Water Simulation`*.
3. You should now have a GameObject in your Scene Hierarchy named WaterSimulation with 4 Components:
    - Fluid Simulation
    - Foam Layer
    - Fluid Flow Mapping
    - Water Surface
4. If you followed step 1 go to step 5. The Terrain and its settings have been automatically assigned to the Fluid Simulation Component. If you did not follow step 1 you will have to assign the following fields:
    - Dimension: The size of your simulation/terrain domain.
    - Terrain Type: **Unity Terrain**, **Heightmap**, **Simple Terrain** which specifies the type of terrain you wish to use.
    - Terrain/[Simple Terrain](#terrain)/Heightmap: The object you want the Fluid Simulation to interact with.
5. Fluid settings, assets, and materials are automatically created in the folder of your scene. You can tweak these values to your liking.
6. Add a [Fluid Modifier Volume](#fluid-modifier-volume) by clicking the GameObject menu and selecting *`Fluid Frenzy > Fluid Source`*.
7. Setup the new Fluid Modifier by placing it in the desired location in the scene and setting up the settings in the Inspector

You now have a functional Fluid Simulation using Fluid Frenzy. Hit Play and see your Terrain being flooded by water!


<a name="setup-terraform-simulation"></a>
### Terraform Simulation

![Terraform Simulation Setup](../../docs/images/gameobject_fluidfrenzy_terraform.png)

These steps will describe how to set up a fluid simulation that will simulate god game-like terraforming. The simulation supports fluids of water and lava, erosion and fluid mixing to turn water and lava into rock. In the current version of **Fluid Frenzy** terraforming only works the [Terraform Terrain](#terraform-terrain).
1. Add a [Terraform Terrain](#terraform-terrain) to your scene by clicking the GameObject menu and selecting *`Fluid Frenzy > Create TerraformTerrain`*.
2. Set up your [Terraform Terrain](#terraform-terrain) by assigning all required settings.
2. Set up the newly created [Terraform Terrain](#terraform-terrain) to your liking.
3. Select your [Terraform Terrain](#terraform-terrain) and add a Terraform Simulation by clicking *`Fluid Frenzy > Terraform Simulation`*.
5. Fluid settings, assets, and materials are automatically created in the folder of your scene. You can tweak these values to your liking.
6. Add a [Fluid Modifier Volume](#fluid-modifier-volume) by clicking the GameObject menu and selecting *`Fluid Frenzy > Fluid Source`*.
7. Set up the new Fluid Modifier by placing it in the desired location in the scene and setting up the settings in the Inspector. You can change the layer to control which fluid the modifier should add to. Layer 1 is Water while Layer 2 is Lava.

You now have a functional Terraform Simulation using Fluid Frenzy. Hit Play and see your Terrain being filled with water and lava!

---

<div style="page-break-after: always;"></div>

<a name="fluid-simulation-components"></a>
## Fluid Simulation Components

These are all the components that control and extend the simulation.

<a name="fluid-simulation"></a>
### Fluid Simulation

**Fluid Simulation** is the core component of Fluid Frenzy. It handles the full simulation and the components attached to it.

![Fluid Simulation](../../docs/images/fluidsimulation.png)

- **Settings** - a [Fluid Simulation Settings](#fluid-simulation-settings) asset that holds the settings to be used for this Fluid Simulation. 
- **Dimension** - is the size simulation in *world space*. `dimension.x is width(x)` `dimension.y is depth(z)`. 
- **Initial Fluid Height** - is a float value of the fluid height when the simulation starts. This is a *world space* height, meaning that any terrain lower than this height will have fluid up to this height and any terrain higher will have no fluid.
- **Initial Fluid Height Texture** - is a texture mask of the fluid height when the simulation starts. This is This is a *world space* height, meaning that any terrain lower than this height will have fluid up to this height and any terrain higher will have no fluid. When combining this with the **Initial Fluid Height** value the maximum for that pixel is taken.
- **Terrain type** - specifies which type of terrain to use as the base ground to flow the fluid simulation over.
    Options:
    - *Unity Terrain* - the simulation uses the **Terrain** assigned to the **Unity Terrain** field.
    - *Simple Terrain* - the simulation uses the [Simple Terrain](#simple-terrain) or a [Terraform Terrain](#terraform-terrain) assigned to the **Simple Terrain** field.
    - *Heightmap* - the simulation will be initialized from and using a height map. This feature can be used if you are using a custom terrain system.  
- **Extension Layers** - fluid simulation extension layers like foam, flow mapping, and terraforming so they are executed within this fluid simulation. Assign any extension fluid layer components that should run with this fluid simulation. 

<div style="page-break-after: always;"></div>

<a name="fluid-simulation-settings"></a>
### Fluid Simulation Settings
[Fluid Simulation Settings](#fluid-simulation-settings) are *Scriptable Object* assets that are assigned to a [Fluid Simulation](#fluid-simulation). It is an asset to make it easier to reuse and modify settings on multiple [Fluid Simulations](#fluid-simulation). To create a [Fluid Simulation Settings](#fluid-simulation-settings) asset click *`Assets > Create > Fluid Frenzy > Simulation Settings`*.

#### Update Mode

![Fluid Simulation Settings](../../docs/images/fluidsimulationsettings_slice_0_0.png)

- **Run in Fixed Update** - allows the user to choose between simulating in *Update* or *Fixed Update*. It is recommended to run in *Fixed Update* for better stability, as the delta time will not fluctuate and the simulation will be in sync with Unity's physics. If your game is using a very high or low 'Time.fixedDeltaTime' value, it is advised to simulate in Update. The simulation will always run at a fixed timestep of 60hz to maintain stability, even if your framerate is higher or lower. This means that if you have a higher framerate, eventually there will be a frame where the simulation does not have to run. Conversely, with a lower framerate, the simulation will need to run multiple times per frame to catch up. This is because 2.5D Fluid simulations tend to become unstable with high timesteps.

#### Wave Simulation Settings

![Fluid Simulation Settings](../../docs/images/fluidsimulationsettings_slice_1_0.png)

These settings control the main part of the simulation, how fast fluids move down the terrain and around obstacles, how fast they dissolve and how high they get in certain regions.

- **Number Of Cells** - controls the number of cells/pixels the simulation will be using. It is recommended to use a power of 2 value like 512x512 or 1024x1024. The higher the value the more accurate the simulation gets, but also more expensive. 
- **Cell Size** - scales the size of each cell to control how fast the fluid flows, a smaller **Cell Size** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - controls how fast the waves and fluid should dampen down to no waves.
- **Acceleration** - controls the speed of the fluid. A higher value means the fluid will move faster.
- **Open Borders** - is used to allow the fluid to leave the simulation. When disabled the fluid will bounce off the borders of the simulation and accumulate over time. 

<sub>* Due to the 2.5D nature of the simulation each cell/pixel represents a world space size: `dimension / Number Of Cells`. This means scaling the number of cells up can cause the fluid to move slower in world space. The simulation tries to automatically scale as best as possible, but can only move so fast before becoming unstable. Therefore at some point making the **Cell Size** lower or **Acceleration** higher will have no effect, if you want your simulation to move faster you will have to reduce the **Number Of Cells**.</sub>

#### Rendering Settings

![Fluid Simulation Settings](../../docs/images/fluidsimulationsettings_slice_2_0.png)

- **Clip Height** - any fluid height below this value will be treated as no fluid. This is to help clipping issues due to floating point impression.

#### CPU>GPU Readback

![Fluid Simulation Settings](../../docs/images/fluidsimulationsettings_slice_3_0.png)

- **CPU Height Read** - the simulation fully runs on the GPU but in some cases, interaction with objects that live in the CPU is desired like floating objects. When enabling this the height and velocity will be read back to the CPU asynchronously. The reason it is readback asynchronously is to prevent stalls and improve performance, this does mean that the CPU data is a few frames behind the GPU simulation.
- **Time Slicing** - to improve the performance further time slicing of the *readback* can be enabled. The selected value means how many *readbacks* will need to be done to get the full simulation back to the CPU. The higher this number, the less expensive the *readback* becomes but the longer it takes before the simulation is fully read back. Time slicing happens from top to bottom of the simulation, meaning the 100/N% in the height will be read back. Only one *readback* per simulation is performed at the same time so the next timeslice section will not start until the previous one is finished.

#### Velocity Field Settings

These settings control the behavior of the Velocity Field. The Velocity Field is a 2D texture used for effects like flow mapping, foam advection, erosion, and sediment advection of eroded materials. It is generated from inputs from outputs generated by the Wave Simulation.

![Fluid Simulation Settings](../../docs/images/fluidsimulationsettings_slice_4_0.png)

- **Velocity Texture Size** - is the size of the Velocity Field
- **Padding Percentage** - the amount of padding borders the velocity flow map. This is used for tiled simulations which are currently disabled. It is recommended to keep this at 0 for now.
- **Velocity Scale** - the amount of the simulation's velocity should be written to the velocity map texture. Higher values mean faster appearing acceleration and flowing fluids. The fluid simulation generated an outflow map for every frame. This outflow turned into a 2D velocity field. The **Velocity Scale** controls how much of this velocity is applied to the final velocity field texture.
- **Velocity Max** - clamps the velocity to a maximum amount.
- **Advection Scale** - scales the distance the velocity [advects](https://en.wikipedia.org/wiki/Advection)/moves itself and other maps like the **Foam Layer**. The larger this value is the further parts of the fluid simulation like foam, dynamic flow mapping and the velocity itself moves.
- **Additive Velocity** - controls of the current calculated velocity should be added(*enabled*) to the previous velocity or overwritten(*disabled*). When using additive velocity there will be effects like swirls and pressure buildup to create foam, when disabled the velocity will remain only what is there for the current frame.
- **Velocity Damping** - scales down the velocity of each frame to slow down the velocity when no velocity gets added anymore. Higher values dampen the velocity faster.
- **Pressure** - scales the compressibility of the fluid's velocity. This means it influences/pushes out to neighboring cells more the higher you set this value. Tweaking this value increases/decreases the size of swirls as well as the size of the pressure field when fluid flows into obstacles.

#### Second Layer Settings

A fluid second layer can be enabled within the [Fluid Simulation](#fluid-simulation) to simulate an extra type of fluid. There is a slight decrease in performance and an increase in VRAM usage but it is more performant than adding a separate [Fluid Simulation](#fluid-simulation). By default, this is disabled except for the Terraform Simulation option where the second layer is used for lava. The settings for this are overrides for the settings of the main layer.

![Fluid Simulation Settings](../../docs/images/fluidsimulationsettings_slice_5_0.png)

- **Second Layer** - enables/disables the second layer.
- **Cell Size** - scales the size of each cell to control how fast the fluid flows, a smaller **Cell Size** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - controls how fast the waves and fluid should dampen down to no waves.
- **Acceleration** - controls the speed of the fluid. A higher value means the fluid will move faster.
- **Velocity Scale** - the amount of the simulation's velocity should be written to the velocity map texture. Higher values mean faster appearing acceleration and flowing fluids. The fluid simulation generated an outflow map for every frame. This outflow turned into a 2D velocity field. The **Velocity Scale** controls how much of this velocity is applied to the final velocity field texture.
- **Use Custom Viscosity** - enables/disables a custom viscosity control which allows you to make the fluid flow slower on slopes as well as stack up to a height before flowing.
- **Viscosity** - scales the speed of the flow, the velocity generated in the velocity field will be the same, but the fluid will leave the cells at a slower rate. The higher the value the more viscous the fluid gets resulting in a slower flow
- **Flow Height** - indicates at which height the fluid should start flowing on flatter surfaces. Fluids like lava have a height thickness to them as they flow, setting this value to a higher value will simulate that effect. There will always be some flow eventually if there is no more fluid left to stack up.

___

<a name="foam-layer"></a>
### Foam Layer

**Foam Layer** is an extension layer that can be attached to the Fluid Simulation. It generates a foam map based on the current state of the simulation. There are several inputs from the [Fluid Simulation](#fluid-simulation) that are used to generate this map (Pressure, Y Velocity, and Slope). The influence of each of these inputs can be controlled by the [Foam Layer Settings](#foam-settings).
*Note: This component lives on a GameObject but also needs to be added to the **Layers** list of the [Fluid Simulation](#fluid-simulation).*  

- **Settings** - a [Foam Layer Settings](#foams-ettings) asset which holds the settings to be used for this Foam Layer

<a name="foam-settings"></a>
### Foam Layer Settings

**Foam Layer Settings** are *Scriptable Object* assets that are assigned to a [Foam Layer](#foam-layer). It is an asset to make it easier to reuse and modify settings on multiple [Foam Layers](#foam-layer). To create a **Foam Layer Settings** asset click *`Assets > Create > Fluid Frenzy > Foam Layer Settings`*.

![Foam settings](../../docs/images/foamsettings.png)

#### Foam Render Settings

- **Foam Texture Size** - is the size of the foam mask.

#### Foam Pressure Settings

- **Pressure Range** - determines the minimum and maximum amount of pressure needed before it contributes to the foam map. Pressures below the minimum value will not add any foam, pressures above the maximum value will add the maximum amount of foam. Anything in between is interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).
- **Pressure Increase** - scales the amount of foam in every frame when the pressure is high enough to contribute to the foam mask.
- **Exponential Decay Rate** - is a scalar that is used to decay the foam exponentially. The more foam there is the faster it decays.
- **Linear Decay Rate** - is a scalar that is subtracted from the wave foam mask every frame.

#### Foam Wave Settings

- **Angle Range** - determines the minimum and maximum wave angle needed before it contributes to the foam mask. Angles below the min value will not add any foam, angles above the max value will add the maximum amount of foam. Anything in between is interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).
- **Angle Increase** - scales the amount of foam in every frame when the wave angle is high enough to contribute to the foam mask.
- **Height Increase** - is the amount of foam added to the foam mask based on the wave Y velocity.
- **Exponential Decay Rate** - is a scalar that is used to decay the foam exponentially. The more foam there is the faster it decays.
- **Linear Decay Rate** - is a scalar that is subtracted from the wave foam mask every frame.

___

<a name="flowmapping"></a>
### Fluid Flow Mapping

**Fluid Flow Mapping** is an extension layer that enables and controls [*flow mapping*](https://catlikecoding.com/unity/tutorials/flow/directional-flow/) functionality in the simulation and rendering side of Fluid Frenzy. The layer generates the *flow map* procedurally using the flow of the fluid simulation. The rendering data is automatically passed to the material assigned to the [Fluid Renderer](#fluid-rendering-components). There are several settings to control the visuals of the flow mapping in the layer which can be set in the [Fluid Flow Mapping Settings](#flowmap-settings) asset assigned to this layer.

- **Settings** - a [Fluid Flow Mapping Settings](#flowmap-settings) asset which holds the settings to be used for this Flow Mapping Layer

<a name="flowmap-settings"></a>
### Fluid Flow Mapping Settings

**Fluid Flow Mapping Settings** are *Scriptable Object* assets that are assigned to a [Fluid Flow Mapping](#fluid-flow-mapping). It is an asset to make it easier to reuse and modify settings on multiple [Fluid Flow Mappings](#fluid-flow-mapping). To create a **Flow Mapping Settings** asset click *`Assets > Create > Fluid Frenzy > Flow Mapping Settings`*.

![Flow mapping settings](../../docs/images/flowmappingsettings.png)

- **Flow Mapping Mode** - selects which mode of flow mapping to use  
Options:
    - *Off* - no flow mapping.
    - *Static* - flow mapping is done in the shader by offsetting the UVs based on the velocity field.
    - *Dynamic* - flow mapping is done in a separate buffer which calculates a delta/offset of the UVs. The UVs are advected similarly to the velocity field and foam mask. The offset is used to find the velocity at the advected UV position to find how much the UV should be advected in this frame. This can allow for more detailed swirling effects but also increases distortion over time.
- **Flow Speed** - is the speed of the flow mapping, higher values mean faster flow, but also more distortion of the UV.
- **Flow Phase Speed** - is the speed before the UVs reset back to 0. Increasing this value reduces the distortion caused by fast-flowing fluids. To hide texture popping on reset the texture gets sampled multiple times and weighted depending on the cycle/phase of the flow mapping.

___

<a name="erosion-layer"></a>
### Erosion Layer

**Erosion Layer** is an extension layer that can be attached to the Fluid Simulation. It makes modifications to the terrain based on the current state of the simulation. Erosion strength depends on the settings, fluid height, and fluid velocity. The modifications made by this layer automatically get applied back to the **SimpleTerrain/TerraformTerrain** and [Fluid Simulation](#fluid-simulation). 

The erosion of terrains is simulated by using 2D textures. The higher the velocity in the velocity field, the more of the terrain is removed/eroded from the heightmap into a sediment map. This sediment map gets updated every frame by adding/removing terrain sediment and then advecting it through the map based on the velocity. The sediment in the sediment map will get deposited back to the terrain heightmap in slower-moving fluids.

![Erosion Layer](../../docs/images/erosionlayer.png)

- **Slippage** - enables/disables erosion caused by slippage of materials. When enabled the top layer of the terrain smooths over time due to erosion.
- **Slope Angle** - the angle at which the slippage should happen. Any terrain angle higher than this value will smooth due to slippage.
- **Slope Smoothness** - scales how smooth the terrain becomes, higher values make the terrain smoother.
- **Hydraulic Erosion** - enables/disables hydraulic erosion caused by fluids flowing over the top layer of the terrain. Faster-flowing fluids erode the terrain faster.
- **Max Sediment** - every cell in the sediment map can only contain this much sediment before the erosion stops in this area.
- **Sediment Dissolve Rate** - the rate at which the terrain will erode. Higher values mean faster erosion, as long as there is room in the sediment map.
- **Sediment Deposit Rate** - the rate sediment gets deposited back into the terrain when it settles due to slow velocity or when the maximum amount of sediment in the cell is reached.
- **Min Tilt Angle** - steeper slopes have stronger hydraulic erosion. Changing the **Min Tilt Angle** causes flat surfaces to have erosion at higher rates. 0 means no erosion on flatter surfaces, and 1 is full erosion on flatter surfaces.
- **Sediment Advection Speed** - the advection speed of the sediment in the eroded sediment map. Higher values transport the sediment farther through the world before depositing. 
*Note: higher values transport sediment further, but this may cause sediment to be lost as the erosion simulation is not mass conserving. Sediment may reach areas where there is no fluid, or leave the simulation*

<a name="terraform-layer"></a>
### Terraform Layer

The **Terraform Layer** is an extension of the [Erosion Layer](#erosion-layer) which allows 'god game-like' features to mix fluids into terrain rock, emit particles when fluids mix, and change terrain types using the **Terrain Modifier** by modifying the terrain heightmap and splatmap. The current support of this layer is the mixing of water and lava to create terrain, adding different terrain types by writing to the terrain heightmap and splatmap, and based on user input and the spawning of particles when fluids mix. 

Terraforming is done using 2D textures for modifications. When two fluids occupy the same sell they remove a certain amount from the fluid heightmap and place it into the *Modify textures*. The *Modify texture* then deposits the mixed fluids as terrain into the terrain heightmap and splatmap.

![Terraform Layer](../../docs/images/terraformlayer.png)

- **Fluid Mixing** - enables/disables fluid mixing of multi-layered fluid simulations. When enabled two fluids occupying the same cell will start mixing together. In the case of this simulation mixing of water and lava occurs by turning the fluids into rocky terrain.
- **Mix Rate** - the rate at which the fluids mix. Higher values mean faster mixing.
- **Mix Scale** - scales the amount of terrain to be added when two fluids mix. You can use this value if you want to have more or less terrain added when fluids mix. **Mix Scale** 1 means for every unit of fluid being mixed, the same amount is added to the terrain. Any **Mix Scale** below 1 causes fewer units of terrain will be added, any **Mix Scale** higher than 1 causes more units of terrain to be added.
- **Deposit Rate** - the rate at which terrain height from mixed fluids is added to the terrain heightmap.
- **Fluid Particles** - the behavior and visual control of the particles that spawn when fluids mix. This is used to spawn steam particles when lava and water touch. You can tweak the color, lifetime, and movement in these settings.
- **Emission Rate** - is the spawn rate of particles when fluids mix. A higher emission rate means more particles will be spawned.

<a name="fluid-rigidbody"></a>
### Fluid RigidBody

**Fluid RigidBody** is a component that can be applied to a GameObject to interact with the fluid simulation. It supports physics features like buoyancy, advection and creating waves. To simulate these effects **CPU Height Read** needs to be enabled.

![Fluid Rigidbody](../../docs/images/fluidrigidbody.png)

#### Waves

- **Create Waves** - when enabled the object will interact with the fluid simulation by creating waves in the direction the object is moving.
- **Wave Radius** - scales the size of the wave.
- **Wave Strength** - scales the height of the wave.
- **Wave Falloff** - changes the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create sharper/flatter wave/vortex shapes. Higher values mean a faster falloff.

#### Splashes

- **Splash Force** - scale the force applied to the fluid simulation when the object lands in the fluid. Faster falling objects create bigger splashes.

#### Physics

- **Advection Speed** - scales the influence the fluid simulation's velocity field has on the object. Higher values will move the object through the fluid at faster speeds.
- **Drag** - the amount of linear drag that is applied when the object is in contact with the fluid.
- **Angular Drag** - the amount of angular/rotational drag that is applied when the object is in contact with the fluid.
- **Buoyancy** - scales the buoyancy of the object. Higher values will make the object pushed up by the fluid more, causing it to float. Lower values will make objects float less, or even sink.

<a name="fluid-simulation-obstacle"></a>
### Fluid Simulation Obstacle
**Fluid Simulation Obstacle** is a component that can be added to any object with a renderer component attached. When this component is attached it will be written into the fluid simulation's heightmap so that the fluid can interact with it. The fluid will flow around or over this obstacle but cannot flow under it so it is advised to use this on those that are mainly round and do not create a convex shape with the terrain.

---

<div style="page-break-after: always;"></div>

<a name="fluid-rendering-components"></a>
## Fluid Rendering Components

The **FluidRenderer** component is responsible for rendering the Fluid Simulation. This component is in charge of creating and rendering the necessary meshes and materials needed for displaying the assigned Fluid Simulation. Users can customize the **FluidRenderer** component to create their own rendering effects, similar to **WaterSurface** and **LavaSurface** renderers.

- **Fluid Material** - is the material the fluid simulation will be rendered with.
- **Simulation** - is the simulation to be rendered.
- **Flow Mapping** - the **Flow Mapping Layer** component whose rendering data will be used to apply flow mapping to the material.
- **Mesh Resolution** - the amount of vertices the mesh is in each axis. It is best to match **Fluid Simulation Settings -** **Number of Cells**.
- **Mesh Blocks** - the amount of blocks the rendering mesh is to be subdivided in to improve GPU performance by culling parts of the renderer.

___

<a name="water"></a>
### Water

#<a name="water-surface"></a>
### Water Surface

![Water Surface](../../docs/images/watersurface.png)

[Water Surface](#water-surface) is an extension of the [FluidRenderer](#fluid-rendering-components) component that specifically deals with rendering water-related elements of the fluid simulation, such as foam. It accomplishes this by assigning the currently active rendering layers to its assigned material.

- **Foam Layer** - assign a [Foam Layer](#foam-layer) component whose foam mask gets applied for foam rendering effects on the water material.

<div style="page-break-after: always;"></div>

#<a name="water-shader"></a>
### Water Shader

**FluidFrenzy/Water** is the shader that is applied to the materials on the [Water Surface](#water-surface) **Fluid Material** field.
There are a lot of material properties available for tweaking to create beautiful-looking water.

##### Lighting

Lighting effect rendering properties

![Water Shader](../../docs/images/watershader_slice_0_0.png)

- **Specular Intensity** - increase/decrease the specular light brightness of the main directional light.
- **Shadows** - enables/disables if the water receives shadows.

##### Reflection

Water's reflection rendering properties.

![Water Shader](../../docs/images/watershader_slice_1_0.png)

- **Planar Reflection** - enables/disables if the water should use planar reflections or just reflection probes.
- **Distortion** - scales the distortion applied to the planar reflections.

##### Absorption

Depth-based control of the water's color and refraction rendering properties. 

![Water Shader](../../docs/images/watershader_slice_2_0.png)

- **Color** 
    - *RGB* - is the color of the water at the maximum depth.
    - *Alpha* - is the base transparency of the water. Any value below 255 will make your water always transparent regardless of depth.
- **Depth Transparency** - scales how transparent the water is based on the depth. Lower values make the water more transparent.
- **Screenspace Refraction** - *enabled:* uses screenspace refraction by using GrabPass to sample what is behind the water, using this allows you to use distortion. *Disabled:* uses alpha blending to simulate water transparency.
- **Distortion** - scales the distortion of the screenspace refraction when enabled.

##### Subsurface scattering

Subsurface scattering rendering effect properties

![Water Shader](../../docs/images/watershader_slice_3_0.png)

- **Color** - the color the water will become when a condition for subsurface scattering is met.
- **Intensity** - scales the base intensity of the subsurface scattering.
- **Light Contribution** - scales the contribution of subsurface scattering when the water is facing away from the light.
- **View Contribution** - scales the contribution of subsurface scattering when the water is facing toward the observer.
- **Foam Contribution** - scales the contribution of subsurface scattering when there is foam in the water.
- **Ambient** - scales the base contribution that can be used to always have some subsurface scattering no matter the contribution of the previous parameters.

##### Waves

Render quality improvements by applying detail waves using normal mapping and displacement mapping.

![Water Shader](../../docs/images/watershader_slice_4_0.png)

- **Normal map** - texture, strength, and tiling options to apply extra detail normals to the water surface. 
- **Vertex Displacement** - applies small displacement waves to the vertices based on the velocity within the velocity field of the fluid simulation.
    - *Tiling* - scales the amount of displacement waves.
    - *Wave Amplitude* - scales the height of the displacement waves.
    - *Wave Speed* - scales the movement speed of the displacement waves.
    - *Wave Length* - scales the size/distance between the displacement waves.
    - *Wave Steepness* - scales the sharpness/smoothness of the displacement waves.
    - *Phase Speed* - scales how fast the waves move up and down.

##### Foam

Foam rendering effect properties.

![Water Shader](../../docs/images/watershader_slice_5_0.png)

- **Foam Albedo** - a texture(RGB) multiplied by the color picker(RGB) is used as the diffuse color of the foam. The texture(A)  multiplied by the color picker(A) is used as a mask on where to apply the foam.
- **Foam Normal Map** - a texture used to add detail to the PBR lighting of the foam.
- **Tiling** - tiles the **Foam Albedo** and **Foam Normal Map** textures.
- **Offset** - offsets the **Foam Albedo** and **Foam Normal Map** textures.
- **Foam Visibility Range** - sets the minimum and maximum values when the foam becomes visible and reaches its maximum strength. The visibility of the foam is determined by the Foam Layer mask multiplied by the Foam Albedo Alpha. Any values below the minimum result in no foam, while values above the maximum apply the full amount of foam. Interpolation between the minimum and maximum values is done using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).

##### Rendering

General rendering settings.

![Water Shader](../../docs/images/watershader_slice_6_0.png)

- **Layer** - which layer from the Fluid Simulation to use.
- **Render Queue** - the rendering order of the material.

___
<div style="page-break-after: always;"></div>

<a name="lava"></a>
### Lava

#<a name="lava-surface"></a>
### Lava Surface
**LavaSurface** is an extension of the [FluidRenderer](#fluid-rendering-components) component. It is modified to allow the generation of a custom heat LUT through its gradient field. This LUT is assigned to the Lava material to determine the emissive color of lava based on factors like the velocity of the lava.

![Lava Surface](../../docs/images/lavasurface.png)

- **Generate Heat LUT** - when enabled the **Heat Gradient** configured will override the *Heat LUT* applied to the **Fluid Material** with a *procedurally generated texture*.
- **Heat Gradient** - The gradient turns into a procedurally generated texture to override the **Fluid Material**.

#<a name="lava-shader"></a>
### Lava Shader

**FluidFrenzy/Lava** is the shader that is applied to the materials on the [Lava Surface](#lava-surface) **Fluid Material** field. The *heat* of the lava is the length of the velocity vector in the velocity field.

![Lava Shader](../../docs/images/lavashader.png)

- **Heat LUT** - is a gradient texture used to determine the color of the lava emission based on the *heat* of the lava.
- **Heat LUT Scale** - is a scale applied to the *heat* when sampling the **Heat LUT** gradient.
- **Albedo** - is the albedo texture of the lava. This is what cold lava will look like.
- **Smoothness Scale** - is the PBR smoothness of the cold lava surface.
- **Normal Map** - this is the normal map for more detailed lighting applied to the cold lava surface.
- **Emission Map** - is a texture used for the emission color of the lava. The sample of this texture is multiplied by the *heat*. 
- **Emission** - is the intensity of the **Heat LUT** sampled based on the **Emission Map** and *heat*.
- **Noise** - a texture used to eliminate tiling from the lava textures.

___

<a name="terrain"></a>
### Terrain

#<a name="simple-terrain"></a>
### Simple Terrain

**Simple Terrain** is a terrain rendering component for fluid simulations that makes use of the [Erosion Layer](#erosion-layer). When the [Erosion Layer](#erosion-layer) makes modifications to the terrain height it is applied directly to the **Simple Terrain** in realtime.

![Simple Terrain](../../docs/images/simpleterrain.png)

- **Terrain Material** - is the material the terrain will be rendered with. Currently, only the **Simple Terrain** and **Terraform Terrain** shaders are supported. Custom shaders can be written.
- **Dimension** - determines the width and height of the terrain.
- **Mesh Resolution** - controls the density of vertices in the mesh for each axis, ideally matching the dimensions of the Source HeightMap.
- **Source Heightmap** - specifies the heightmap applied to the terrain with the red channel representing base height and the green channel showing erodible layers above it. Using a 16-bit per channel texture is recommended to avoid artifacts like stepping or terracing.
- **Height Scale** - adjusts the overall height of the terrain by applying a multiplier to both the red and green channels of the Source Heightmap.

#<a name="terraform-terrain"></a>
### Terraform Terrain
The **Terraform Terrain** component is an extension of the **Simple Terrain** component. It adds an extra [splat map](https://en.wikipedia.org/wiki/Texture_splatting) that the [Terraform Layer](#terraform-layer) makes modifications to. This splat map is used to represent different terrain layers on the base layer of the terrain. It is rendered by the **FluidFrenzy/TerraformTerrain** shader.

![Terraform Terrain](../../docs/images/terraformterrain.png)

- **Splatmap** - is applied to the Terraformed terrain as a mask to determine which layer of textures and material properties of the assigned **Terrain Material** to use. The splat map is only applied to the base layer since there is only 1 erodible material.

---

<div style="page-break-after: always;"></div>

<a name="fluid-modifiers"></a>
## Fluid Modifiers

**Fluid Modifiers** are *Components* that can be attached to a *GameObject*. They are used to interact with the simulation in multiple ways, ranging from adding/removing fluids and applying forces. There are several **Fluid Modifier** types each with specific behaviors.

<a name="fluid-modifier-volume"></a>
### Fluid Modifier Volume

**Fluid Modifier Volume** has multiple types that can be used simultaneously. The types are:

![Fluid Modifier Volume](../../docs/images/fluidsource.png)

#<a name="fluid-volume-source"></a>
### Source

Is used to add/remove fluid from the simulation.
- **Mode** - is the input mode of the modifier.
    Options:
    - *Circle* - the modifier inputs the fluid in a circular shape.
    - *Box* - the modifier inputs fluid in a rectangular shape.
    - *Texture* - the modifier inputs the fluid from a source texture.
- **Dynamic** - enables/disables if the modifier can be moved. When disabled the modifier will write to a static texture at the start of the simulation. This is useful if you have many fluid sources and want to improve your performance.
- **Size** - the size of the volume.
- **Strength** - the amount of fluids input by the volume
- **Falloff** - changes the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create large but more focused fluid sources. A higher value means the source strength falls off faster.
- **Texture** - the texture to use as an input. Only the red channel is used. 

#<a name="fluid-volume-flow"></a>
### Flow

is used to add a force to the velocity field of the simulation. An example of this would be a boat's motor pushing away foam or a whirlpool.

- **Mode** - is the input mode of the modifier.
    Options:
    - *Circle* - the modifier inputs the flow in a direction within a circular shape.
    - *Vortex* - the modifier inputs the flow of a vortex. The flow shape will be circular but has control over the radial flow and the inward flow
    - *Texture* - the modifier inputs the flow direction from a flow map texture.
- **Direction** - is the 2D direction that the flow force will be applied in. On a flat surface `direction.x` is in X world space and `direction.y` is Z in world space. If the surface is sloped either component will appear to go more in the world space Y since the velocity field is in 2D. 
- **Size** - is the size of the flow volume.
- **Strength** is the amount of flow applied to the velocity field. For Vortex mode, this is the inward flow to the center.
- **Falloff** - changes the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create sharper/flatter wave/vortex shapes. Higher values mean a faster falloff.
- **Radial Flow Strength** - the amount of radial flow applied to the velocity field for vortex mode. Higher values make vortices flow faster.
- **Additive** - *enabled:* adds the flow to the current flow in the velocity field. *disabled:* replaces the current flow of the velocity field.
- **Texture** - a flow map texture that writes its red & green channels into the velocity field. 

#<a name="fluid-volume-force"></a>
### Force

Is used to add a displacement force to the simulation. There are several types of forces ranging from waves, splashes and whirlpools.

- **mode** is the input mode of the modifier.
    Options:
    - *Circle* - creates a force in a direction within a circular shape. This is useful for creating waves and pushing fluids around.
    - *Vortex* - create a force that moves fluids down with a distance-based falloff, creating a vortex/whirlpool-like shape.
    - *Splash* - creates a splash effect on the fluid surface. Pushes fluids in an outward direction from the center so that the simulation can move it back in, causing a splash effect.
    - *Texture* - the red channel of this texture will be used as a height displacement. This can be used to create multiple fluid effects in one drawcall.
- **Size** - the size of the modifier.

- **Direction** - The direction the applied force causes the waves to move in. `direction.x` is X in world space and `direction.y` is Z in world space.
- **Strength** - the height of the wave/splash, the depth of the vortex, or the strength to apply the supplied texture.
- **Falloff** - changes the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create sharper/flatter wave/vortex shapes. Higher values mean a faster falloff.

<a name="fluid-modifier-waves"></a>
### Fluid Modifier Waves

**Fluid Modifier Waves** applies a displacement force to the simulation to replicate waves generated by external forces like wind. 

![Fluid Modifier Waves](../../docs/images/fluidmodifier_waves.png)

- **Strength** - the amount of force to be applied in regions where waves are being generated.
- **Octave 1** - are settings to generate random waves
- **Octave 2** - are settings to generate a second set of random waves.
- **Noise Octave** is used to create small up-and-down river-like waves. This uses the input of Perlin noise to break up repetition. Hence the name, **Noise Waves**.
Each of these Waves has the following settings
    - *Frequency* - of waves. Higher values mean more waves.
    - *Amplitude* - of the waves. Higher values create higher waves
    - *Speed* - the wave travels at. Higher values will move the wave faster in the specified direction.
    - *Direction* - the direction the wave travels in.

<a name="fluid-modifier-pressure"></a>
### Fluid Modifier Pressure

**Fluid Modifier Pressure** applies a displacement force to the simulation based on the pressure generated by the velocity field. Areas of high pressure where fluid pushes against an obstacle like terrain or object will become elevated making the fluid field appear like it is accumulating before spreading around the obstacle. 
*Note: for this modifier to function the simulation needs to use additive velocity mode in the [Fluid Simulation Settings](#fluid-simulation-settings)*.

![Fluid Modifier Pressure](../../docs/images/fluidmodifier_pressure.png)

- **Pressure Range** - is the range at which the pressure is high enough to start applying forces to the fluid simulation. Any pressure below the minimum value will apply no forces, and anything above the maximum will apply the full strength. Anything in between is interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).
- **Strength** - is the amount of force to be applied when there is enough pressure built up in the fluid simulation.

---

<div style="page-break-after: always;"></div>

<a name="future-updates-roadmap"></a>
## Future Updates & Roadmap

These are some future features that are planned to be supported in Fluid Frenzy.

- **Performance optimizations:** Continuously work on improving the performance of the simulation and rendering to allow for larger and more complex fluid simulations without sacrificing speed.
- **Custom shader support:** Enable developers to create and implement custom shaders for the fluid simulation and rendering, providing more options for visual effects.
- **Tiled Simulations:** Allow neighboring simulations to interact with each other. The purpose of tiled simulations is to create bigger simulation areas where simulations that are too far away can be disabled.
- **Simulation Regions/Domains:** Allow only parts of the terrain to interact with the simulation, creating smaller simulations within a terrain instead of the full terrain being used by automatically grabbing the correct area of the source terrains.
- **URP & HDRP Support:** The simulation itself works within different render pipelines but the rendering of the simulation is currently not yet supported. The plan is to support both URP and HDRP.
- **Underwater Rendering:** Enable rendering features like underwater rendering when the player/camera goes below the water.
- **Fluid Surface LOD:** Improve rendering performance by implementing a LOD system for rendering fluid surfaces.