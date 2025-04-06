---
title: Fluid Simulation Components
permalink: /docs/fluid_simulation_components/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

These are all the components that control and extend the simulation.

<a name="fluid-simulation"></a>
### Flux/Flow Fluid Simulation

**Flux Fluid Simulation** and **Flow Fluid Simulation** are the core components of Fluid Frenzy. Both simulations handle the full simulation and the components attached to it using a different method. The user can choose which to simulation to use in their scene depending on which is more suitable for their needs. 

**Flux Fluid Simulation** makes use a Flux based [algorithm](https://www.researchgate.net/publication/4295561_Fast_Hydraulic_Erosion_Simulation_and_Visualization_on_GPU) where the inflow/outflow from/to each neighbouring sell is calculated. The outflow field is used to modify the height of the fluid field to create waves and can be converted into a velocity field.

| Pros | Cons |
| ---- | ---- |
| Stable at any height| Higher performance cost. |
| Smoother waves. | Higher VRAM usage. |
| Allows for more velocity solving (vortices). | Decoupled Wave/Velocity causing velocity field and [Flow Mapping](#flowmapping) to lag behind abruptly changing waves. |
| Control waves and flow mapping separately. | |

**Flow Fluid Simulation** makes use of a Velocity based [algorithm](https://github.com/matthias-research/pages/blob/master/publications/hfFluid.pdf) where the fluid simulation calculates a velocity field based on the height of the fluid, which in turn is used to modify the height field to create waves.
Due to the lower cost and simplicity of the fluid simulation multiple iterations can run per frame at the same cost as **Flux Fluid Simulation**, allowing for faster moving fluids while remaining stable.

| Pros | Cons |
| ---- | ---- |
| Lower performance cost. | Reduces velocity on height fluids to remain stable. |
| Lower VRAM usages. | Lower quality velocity field. |
| More control over fluid velocity .| Sharper wave edges |
| Slower moving fluids can have even lower cost. | Less stability on fast moving fluids. |
| Waves and velocity field are coupled making [Flow Mapping](#flowmapping) and waves in sync. | |

![Fluid Simulation](../../assets/images/fluidsimulation.png)

- **Settings** - a [Fluid Simulation Settings](#flux-fluid-simulation-settings) asset that holds the settings to be used for this Fluid Simulation. 
- **Dimension Mode** - select the mode to be used when calculating/setting the dimension of the simulation
    Options:
    - *Bounds* - Allows the user to set custom bounds size which is used to calculate the **world space cell size** based on the **dimension** and **Number Of Cells**. Use this for square simulations to automatically calculate the correct world space cell size.
    - *CellSize* - Allows the user to set the size of each **Number Of Cells** cell to determine the size of dimension, use this method for none square simulations to automatically get the bounds
- **Dimension** - is the size simulation in *world space*. `dimension.x is width(x)` `dimension.y is depth(z)`. 
- **World Space Cell Size** - the size of each cell of the fluid simulation's buffer (**Number Of Cells**)

- **Iterations** - the number of internal iterations to perform in order to increase the stability of the simulation. Lower **Cell Size Scale** required more iterations. Higher iteration counts but increase the cost of the simulation.

- **Fluid Base Height** - specifies a height that can be used to apply a height offset to the fluid. This can be used to reduce/remove clipping with tessellated terrains.
- **Initial Fluid Height** - specifies the fluid height when the simulation starts. This is a *terrain space* height, meaning that any terrain lower than this height will have fluid up to this height and any terrain higher will have no fluid.
- **Initial Fluid Height Texture** - is a texture mask of the fluid height when the simulation starts. This is a *terrain space* height, meaning that any terrain lower than this height will have fluid up to this height and any terrain higher will have no fluid. When combined with the **Initial Fluid Height** value the maximum for that pixel is taken.
- **Terrain type** - specifies which type of terrain to use as the base ground to flow the fluid simulation over.
    Options:
    - *Unity Terrain* - use a **Terrain** assigned to the **Unity Terrain** field.
    - *Simple Terrain* - use a [Simple Terrain](../terrain#simple-terrain) or a [Terraform Terrain](../terrain#terraform-terrain) assigned to the **Simple Terrain** field.
    - *Heightmap* - use a **Texture2D** as a heightmap. This feature can be used if you are using a custom terrain system.  
    - *MeshCollider* - use a **MeshCollider** assigned to the **meshCollider** field. This feature can be used if you want to use a mesh as the simulation's base ground.
- **Extension Layers** - fluid simulation extension layers like foam, flow mapping, and terraforming so they are executed within this fluid simulation. Assign any extension fluid layer components that should run with this fluid simulation. 

<div style="page-break-after: always;"></div>

<a name="flux-fluid-simulation-settings"></a>
### Flux Fluid Simulation Settings
[Fluid Simulation Settings](#flux-fluid-simulation-settings) are *Scriptable Object* assets that are assigned to a [Fluid Simulation](#fluid-simulation). It is an asset to make it easier to reuse and modify settings on multiple [Fluid Simulations](#fluid-simulation). To create a [Fluid Simulation Settings](#flux-fluid-simulation-settings) asset click *`Assets > Create > Fluid Frenzy > Simulation Settings`*.

#### Update Mode

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_0_0.png)

- **Run in Fixed Update** - choose between simulating in *Update* or *Fixed Update*. It is recommended to run in *Fixed Update* for better stability, as the delta time will not fluctuate and the simulation will be in sync with Unity's physics. If your game is using a very high or low 'Time.fixedDeltaTime' value, it is advised to simulate in Update. The simulation will always run at a fixed timestep of 60hz to maintain stability, even if your framerate is higher or lower. This means that if you have a higher framerate, eventually there will be a frame where the simulation does not have to run. Conversely, with a lower framerate, the simulation will need to run multiple times per frame to catch up. This is because 2.5D Fluid simulations tend to become unstable with high timesteps.

#### Wave Simulation Settings

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_1_0.png)

These settings control the main part of the simulation, how fast fluids move down the terrain and around obstacles, how fast they dissolve and how high they get in certain regions.

- **Number Of Cells** - controls the resolution of the simulation's grid(2D). It is recommended to use a power of 2 value like 512x512 or 1024x1024. The higher the value the more accurate the simulation is, but increase the cost(frame time and memory) of the simulation. 
- **Cell Size** - adjusts the size of each cell to control how fast the fluid flows, a smaller **Cell Size** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - adjusts how fast the waves in the fluid simulation should dampen down to no waves.
- **Acceleration** - adjusts the speed of the fluid. A higher value means the fluid will move faster.
- **Open Borders** - determines whether to allow the fluid to leave the simulation. When disabled the fluid will bounce off the borders of the simulation and accumulate over time. 

<sub>* Due to the 2.5D nature of the simulation each cell/pixel represents a world space size: `dimension / Number Of Cells`. This means scaling the number of cells up can cause the fluid to move slower in world space. The simulation tries to automatically scale as best as possible, but can only move so fast before becoming unstable. Therefore at some point making the **Cell Size** lower or **Acceleration** higher will have no effect, if you want your simulation to move faster you will have to reduce the **Number Of Cells**.</sub>

#### Rendering Settings

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_2_0.png)

- **Clip Height** - adjusts the height when a cell is treated as having now fluid. Any fluid cell's height below this value will be treated as no fluid. This is to help reduce clipping issues due to floating point impression.

#### CPU>GPU Readback

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_3_0.png)

- **CPU Height Read** - the simulation fully runs on the GPU but in some cases, interaction with objects that live in the CPU is desired like floating objects. When enabling this the simulation data for height and velocity will be read back to the CPU asynchronously. The reason the simulation data is readback asynchronously is to prevent stalls and improve performance, this does mean that the CPU data is a few frames behind the GPU simulation.
- **Time Slicing** - to improve the performance further time slicing of the *readback* can be enabled. The selected value means how many *readbacks* will need to be done to get the full simulation back to the CPU. The higher this number, the less expensive the *readback* becomes but the longer it takes before the simulation is fully read back. Time slicing happens from top to bottom of the simulation, meaning the 100/N% in the height will be read back. Only one *readback* per simulation is performed at the same time so the next timeslice section will not start until the previous one is finished.

#### Velocity Field Settings

These settings control the behavior of the Velocity Field. The Velocity Field is a 2D texture used for effects like flow mapping, foam advection, erosion, and sediment advection of eroded materials. It is generated from inputs from outputs generated by the Wave Simulation.

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_4_0.png)

- **Velocity Texture Size** - controls the resolution of the Velocity Field
- **Padding Percentage** - the amount of padding borders the velocity flow map. This is used for tiled simulations which are currently disabled. It is recommended to keep this at 0 if you do not use tiling.
- **Velocity Scale** - the amount of the simulation's velocity should be written to the velocity map texture. Higher values mean faster appearing acceleration and flowing fluids. The fluid simulation generated an outflow map for every frame. This outflow turned into a 2D velocity field. The **Velocity Scale** controls how much of this velocity is applied to the final velocity field texture.
- **Velocity Max** - clamps the velocity field to a maximum amount.
- **Advection Scale** - scales the distance the velocity [advects](https://en.wikipedia.org/wiki/Advection)/moves itself and other maps like the **Foam Layer**. The larger this value is the further parts of the fluid simulation like foam, dynamic flow mapping and the velocity itself moves.
- **Additive Velocity** - controls of the current calculated velocity should be added(*enabled*) to the previous velocity or overwritten(*disabled*). 
    - **Enabled**: Accumulates velocity the from the current frame onto the previous frame's velocity. This causes effects like swirls and pressure buildup to create foam. 
    - **Disable**: The velocity field will contain the velocity calculate based on on the fluid's movement on that frame.
- **Velocity Damping** - scales down the velocity of each frame to slow down the velocity when no velocity gets added anymore. Higher values dampen the velocity faster.
- **Pressure** - scales the compressibility of the fluid's velocity. This means it influences/pushes out to neighboring cells more the higher you set this value. Tweaking this value increases/decreases the size of swirls as well as the size of the pressure field when fluid flows into obstacles.

#### Second Layer Settings

A fluid second layer can be enabled within the [Fluid Simulation](#fluid-simulation) to simulate an extra type of fluid. There is a slight decrease in performance and an increase in VRAM usage but it is more performant than adding a separate [Fluid Simulation](#fluid-simulation). By default, this is disabled except for the Terraform Simulation option where the second layer is used for lava. The settings for this are overrides for the settings of the main layer.

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_5_0.png)

- **Second Layer** - enable or disable the second layer.
- **Cell Size** - adjusts the second layer's size of each cell to control how fast the fluid flows, a smaller **Cell Size** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - adjusts how fast the second layer's waves in the fluid simulation should dampen down to no waves.
- **Acceleration** - adjusts the speed of the fluid's second layer. A higher value means the fluid will move faster.
- **Velocity Scale** - the amount velocity of the FluxFluidSimulation's second layer should be written to the velocity map texture. Higher values mean faster appearing acceleration and flowing fluids. The fluid simulation generated an outflow map for every frame. This outflow turned into a 2D velocity field. The velocityScale controls how much of this velocity is applied to the final velocity field texture.
- **Use Custom Viscosity** - Enables/Disables a custom viscosity control for the second layer to allow the fluid to flow slower on slopes as well as stack up to a height before flowing.
- **Viscosity** - scales the speed of the second layer's fluid flow, the velocity generated in the velocity field will be the same, but the fluid will leave the cells at a slower rate. The higher the value the more viscous the fluid gets resulting in a slower flow.
- **Flow Height** - indicates at which height the fluid second layer should start flowing on flatter surfaces. Fluids like lava have a height thickness to them as they flow, setting this value to a higher value will simulate that effect. There will always be some flow eventually if there is no more fluid left to stack up.


<div style="page-break-after: always;"></div>

<a name="flow-fluid-simulation-settings"></a>
### Flow Fluid Simulation Settings
[Fluid Simulation Settings](#flow-fluid-simulation-settings) are *Scriptable Object* assets that are assigned to a [Fluid Simulation](#fluid-simulation). It is an asset to make it easier to reuse and modify settings on multiple [Fluid Simulations](#fluid-simulation). To create a [Fluid Simulation Settings](#flow-fluid-simulation-settings) asset click *`Assets > Create > Fluid Frenzy > Simulation Settings`*.

#### Update Mode

![Fluid Simulation Settings](../../assets/images/flow_fluidsimulationsettings_slice_0_0.png)

- **Run in Fixed Update** - choose between simulating in *Update* or *Fixed Update*. It is recommended to run in *Fixed Update* for better stability, as the delta time will not fluctuate and the simulation will be in sync with Unity's physics. If your game is using a very high or low 'Time.fixedDeltaTime' value, it is advised to simulate in Update. The simulation will always run at a fixed timestep of 60hz to maintain stability, even if your framerate is higher or lower. This means that if you have a higher framerate, eventually there will be a frame where the simulation does not have to run. Conversely, with a lower framerate, the simulation will need to run multiple times per frame to catch up. This is because 2.5D Fluid simulations tend to become unstable with high timesteps.

#### Wave Simulation Settings

![Fluid Simulation Settings](../../assets/images/flow_fluidsimulationsettings_slice_1_0.png)

These settings control the main part of the simulation, how fast fluids move down the terrain and around obstacles, how fast they dissolve and how high they get in certain regions.

- **Number Of Cells** - controls the resolution of the simulation's grid(2D). It is recommended to use a power of 2 value like 512x512 or 1024x1024. The higher the value the more accurate the simulation is, but increase the cost(frame time and memory) of the simulation. 
- **Cell Size Scale** - adjusts the size of each cell to control how fast the fluid flows, a smaller **Cell Size Scale** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - adjusts how fast the waves in the fluid simulation should dampen down to no waves.
- **Acceleration** - adjusts the speed of the fluid. A higher value means the fluid will move faster.
- **Acceleration Max** - clamps the acceleration of the fluid to a maximum value. Limiting the acceleration helps create different fluid behavior and improves simulation stability by slowing down the fluid.
- **Velocity Max** - clamps the velocity of the fluid to a maximum value. Limiting the velocity helps create different fluid behavior and improves simulation stability by slowing down the fluid.
- **Open Borders** - determines whether to allow the fluid to leave the simulation. When disabled the fluid will bounce off the borders of the simulation and accumulate over time. 

<sub>* Due to the 2.5D nature of the simulation each cell/pixel represents a world space size: `dimension / Number Of Cells`. This means scaling the number of cells up can cause the fluid to move slower in world space. The simulation tries to automatically scale as best as possible, but can only move so fast before becoming unstable. Therefore at some point making the **Cell Size** lower or **Acceleration** higher will have no effect, if you want your simulation to move faster you will have to reduce the **Number Of Cells**.</sub>

![Fluid Simulation Settings](../../assets/images/flow_fluidsimulationsettings_slice_2_0.png)

#### Overshooting Reduction

- **Overshooting Reduction** - overshooting reduction is a technique used in simulations to mitigate the amplification of wave edges that occur when waves transition from deeper to shallower fluids, preventing spike artifacts in the results. This can come at the cost of mass converservation.
- **Overshooting Edge** - adjusts a threshold that determines the sensitivity to changes in wave height when a wave exits deep fluids and enters shallow fluids.
- **Overshooting Scale** - adjusts a scaling factor that adjusts the magnitude of the correction applied to reduce overshooting at detected edges.

#### Rendering Settings

![Fluid Simulation Settings](../../assets/images/flow_fluidsimulationsettings_slice_3_0.png)

- **Clip Height** - adjusts the height when a cell is treated as having now fluid. Any fluid cell's height below this value will be treated as no fluid. This is to help reduce clipping issues due to floating point impression.

#### CPU>GPU Readback

![Fluid Simulation Settings](../../assets/images/flow_fluidsimulationsettings_slice_4_0.png)

- **CPU Height Read** - the simulation fully runs on the GPU but in some cases, interaction with objects that live in the CPU is desired like floating objects. When enabling this the simulation data for height and velocity will be read back to the CPU asynchronously. The reason the simulation data is readback asynchronously is to prevent stalls and improve performance, this does mean that the CPU data is a few frames behind the GPU simulation.
- **Time Slicing** - to improve the performance further time slicing of the *readback* can be enabled. The selected value means how many *readbacks* will need to be done to get the full simulation back to the CPU. The higher this number, the less expensive the *readback* becomes but the longer it takes before the simulation is fully read back. Time slicing happens from top to bottom of the simulation, meaning the 100/N% in the height will be read back. Only one *readback* per simulation is performed at the same time so the next timeslice section will not start until the previous one is finished.

#### Evaporation Settings

![Evaporation Settings](../../assets/images/evaporation_settings.png)
- **Linear Evaporation** - the amount of fluid removed from the fluid simulation each second. fluid -= linearEvaporation * dt.
- **Exponential Evaporation**- the amount of fluid removed from the fluid simulation based on the amount currently there. Move fluid means a higher amount will be removed. fluid -= fluid * proportionalEvaporation * dt.

#### Second Layer Settings

A fluid second layer can be enabled within the [Fluid Simulation](#fluid-simulation) to simulate an extra type of fluid. There is a slight decrease in performance and an increase in VRAM usage but it is more performant than adding a separate [Fluid Simulation](#fluid-simulation). By default, this is disabled except for the Terraform Simulation option where the second layer is used for lava. The settings for this are overrides for the settings of the main layer.

![Fluid Simulation Settings](../../assets/images/flow_fluidsimulationsettings_slice_5_0.png)

- **Second Layer** - enable or disable the second layer.
- **Cell Size** - scales the size of each cell to control how fast the fluid flows, a smaller **Cell Size** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - controls how fast the waves and fluid should dampen down to no waves.
- **Acceleration** - controls the speed of the fluid. A higher value means the fluid will move faster.
- **Acceleration Max** - clamps the acceleration of the second fluid layer to a maximum value. Limiting the acceleration helps create different fluid behavior and improves simulation stability by slowing down the fluid.
- **Velocity Max** - clamps the velocity of the second fluid layer fluid to a maximum value. Limiting the velocity helps create different fluid behavior and improves simulation stability by slowing down the fluid.

___

<a name="foam-layer"></a>
### Foam Layer

**Foam Layer** is an extension layer that can be attached to the Fluid Simulation. It generates a foam map based on the current state of the simulation. There are several inputs from the [Fluid Simulation](#fluid-simulation) that are used to generate this map (Pressure, Y Velocity, and Slope). The influence of each of these inputs can be controlled by the [Foam Layer Settings](#foam-settings).
*Note: This component lives on a GameObject but also needs to be added to the **Layers** list of the [Fluid Simulation](#fluid-simulation).*  

- **Settings** - a [Foam Layer Settings](#foam-settings) asset which holds the settings to be used for this Foam Layer

<a name="foam-settings"></a>
### Foam Layer Settings

**Foam Layer Settings** are *Scriptable Object* assets that are assigned to a [Foam Layer](#foam-layer). It is an asset to make it easier to reuse and modify settings on multiple [Foam Layers](#foam-layer). To create a **Foam Layer Settings** asset click *`Assets > Create > Fluid Frenzy > Foam Layer Settings`*.

![Foam settings](../../assets/images/foamsettings.png)

#### Foam Render Settings

- **Foam Texture Size** - is the size of the foam mask.

#### Foam Decay Settings

- **Exponential Decay Rate** - adjusts the rate at which foam decays exponentially in each frame; higher foam levels result in faster decay.
- **Linear Decay Rate** - adjusts the amount of foam to be subtracted from the wave foam mask in each frame.

#### Foam Pressure Settings
*This feature is only available for the FluxFluidSimulation.*
- **Pressure Foam** - toggles the use of the FluxFluidSimulation pressure field as the input for generating foam.
- **Pressure Range** - defines the minimum and maximum pressure values required for foam generation. Pressures below the minimum threshold will not contribute to the foam mask, while pressures exceeding the maximum threshold will add foam at the maximum level. Intermediate values are interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).
- **Pressure Increase** - adjusts the amount of foam added in each frame when the pressure exceeds the minimum threshold for contributing to the foam mask.

#### Foam Wave Settings
- **Wave Foam** - toggles the use of the FluidSimulation wave height and angle as the input for generating foam.
- **Angle Range** - defines the minimum and maximum wave angles required for contribution to the foam mask. Angles below the minimum do not add foam, while angles above the maximum contribute the maximum foam value. Intermediate values are interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).
- **Angle Increase** - adjusts the amount of foam added to the foam mask in each frame when the wave angle exceeds the minimum threshold for contribution.
- **Height Increase** - adjusts the amount of foam added to the foam mask based on the vertical (Y) velocity of the wave.

#### Shallow Foam Settings
- **Shallow Foam** - toggles the option to apply foam based on the velocity/speed in specified shallow locations.
- **Amount** - adjusts the amount of foam added to the foam mask in each frame when the velocity is within the velocity range and fluid depth.
- **Velocity Range** - adjusts the range when there is enough velocity to apply foam and when to apply the maximum amount of foam. Velocity below the minimum threshold will not contribute to the foam mask, while veocity exceeding the maximum threshold will add foam at the maximum amount. Intermediate values are interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).		
- **Depth** - adjusts the depth of the fluid in which foam will be added, any fluid higher than this value will not add any foam.

### Turbulence Foam Settings
- **Turbulence Foam** - toggles the foam based on the velocity difference at a location.
- **Amount** - adjusts the amount of foam to apply based on the difference/turbulence in the velocity field. 

___

<a name="flowmapping"></a>
### Fluid Flow Mapping

**Fluid Flow Mapping** is an extension layer that enables and controls [*flow mapping*](https://catlikecoding.com/unity/tutorials/flow/directional-flow/) functionality in the simulation and rendering side of Fluid Frenzy. The layer generates the *flow map* procedurally using the flow of the fluid simulation. The rendering data is automatically passed to the material assigned to the [Fluid Renderer](#fluid-rendering-components). There are several settings to control the visuals of the flow mapping in the layer which can be set in the [Fluid Flow Mapping Settings](#flowmap-settings) asset assigned to this layer.

- **Settings** - a [Fluid Flow Mapping Settings](#flowmap-settings) asset which holds the settings to be used for this Flow Mapping Layer

<a name="flowmap-settings"></a>
### Fluid Flow Mapping Settings

**Fluid Flow Mapping Settings** are *Scriptable Object* assets that are assigned to a [Fluid Flow Mapping](#fluid-flow-mapping). It is an asset to make it easier to reuse and modify settings on multiple [Fluid Flow Mappings](#fluid-flow-mapping). To create a **Flow Mapping Settings** asset click *`Assets > Create > Fluid Frenzy > Flow Mapping Settings`*.

![Flow mapping settings](../../assets/images/flowmappingsettings.png)

- **Flow Mapping Mode** - choose the method for flow mapping.
Options:
    - *Off* - no flow mapping applied.
    - *Static* - flow mapping is performed directly in the shader by offsetting UV coordinates based on the velocity field.
    - *Dynamic* - flow mapping utilizes a separate buffer to calculate UV offsets. The UVs are advected in a manner similar to the velocity field and foam mask. In this mode, the offset is used to determine the velocity at the advected UV position, allowing for more intricate swirling effects. However, this can result in increased distortion over time.
- **Flow Speed** - adjusts the speed of the flow mapping, higher values mean faster flow, but also more distortion of the UV.
- **Flow Phase Speed** - adjusts the rate at which UVs reset to their original position (0). Increasing this value reduces the distortion caused by fast-flowing fluids. To hide texture popping on reset the texture gets sampled multiple times and weighted depending on the cycle/phase of the flow mapping.

___

<a name="erosion-layer"></a>
### Erosion Layer

**Erosion Layer** is an extension layer that can be attached to the Fluid Simulation. It makes modifications to the terrain based on the current state of the simulation. Erosion strength depends on the settings, fluid height, and fluid velocity. The modifications made by this layer automatically get applied back to the **SimpleTerrain/TerraformTerrain** and [Fluid Simulation](#fluid-simulation). 

The erosion of terrains is simulated by using 2D textures. The higher the velocity in the velocity field, the more of the terrain is removed/eroded from the heightmap into a sediment map. This sediment map gets updated every frame by adding/removing terrain sediment and then advecting it through the map based on the velocity. The sediment in the sediment map will get deposited back to the terrain heightmap in slower-moving fluids.

![Erosion Layer](../../assets/images/erosionlayer.png)

- **Slippage** - enables/disables erosion caused by slippage of materials. When enabled the top layer of the terrain smooths over time due to erosion.
- **Slope Angle** - adjusts the angle at which the slippage should happen. Any terrain angle higher than this value will smooth due to slippage.
- **Slope Smoothness** - adjusts how smooth the terrain becomes, higher values make the terrain smoother.
- **Hydraulic Erosion** - enables/disables hydraulic erosion caused by fluids flowing over the top layer of the terrain. Faster-flowing fluids erode the terrain faster.
- **Max Sediment** - adjusts the amount of sediment every cell in the sediment map can contain before the erosion stops in this area.
- **Sediment Dissolve Rate** - adjusts the rate at which the terrain will erode. Higher values mean faster erosion, as long as there is room in the sediment map.
- **Sediment Deposit Rate** - adjusts the rate sediment gets deposited back into the terrain when it settles due to slow velocity or when the maximum amount of sediment in the cell is reached.
- **Min Tilt Angle** - adjusts the rate of hydraulic erosion on slopes. Steeper slopes have stronger hydraulic erosion. Changing the **Min Tilt Angle** causes flat surfaces to have erosion at higher rates. 
    - 0 means no erosion on flatter surfaces, 
    - 1 is full erosion on flatter surfaces.
- **Sediment Advection Speed** - adjusts the advection speed of the sediment in the eroded sediment map. Higher values transport the sediment farther through the world before depositing. 
*Note: higher values transport sediment further, but this may cause sediment to be lost as the erosion simulation is not mass conserving. Sediment may reach areas where there is no fluid, or leave the simulation*

<a name="terraform-layer"></a>
### Terraform Layer

The **Terraform Layer** is an extension of the [Erosion Layer](#erosion-layer) which allows 'god game-like' features to mix fluids into terrain rock, emit particles when fluids mix, and change terrain types using the **Terrain Modifier** by modifying the terrain heightmap and splatmap. The current support of this layer is the mixing of water and lava to create terrain, adding different terrain types by writing to the terrain heightmap and splatmap, and based on user input and the spawning of particles when fluids mix. 

Terraforming is done using 2D textures for modifications. When two fluids occupy the same sell they remove a certain amount from the fluid heightmap and place it into the *Modify textures*. The *Modify texture* then deposits the mixed fluids as terrain into the terrain heightmap and splatmap.

![Terraform Layer](../../assets/images/terraformlayer.png)

- **Fluid Mixing** - enables/disables fluid mixing of multi-layered fluid simulations. When enabled two fluids occupying the same cell will start mixing together. In the case of this simulation mixing of water and lava occurs by turning the fluids into rocky terrain.
- **Mix Rate** - adjusts the rate at which the fluids mix. Higher values mean faster mixing.
- **Mix Scale** - adjusts the amount of terrain to be added when two fluids mix. You can use this value if you want to have more or less terrain added when fluids mix. **Mix Scale** 1 means for every unit of fluid being mixed, the same amount is added to the terrain. Any **Mix Scale** below 1 causes fewer units of terrain to be added, any **Mix Scale** higher than 1 causes more units of terrain to be added.
- **Deposit Rate** - adjusts the rate at which terrain height from mixed fluids is added to the terrain heightmap.
- **Fluid Particles** - defines the behavior and visual control of the particles that spawn when fluids mix. This can be used to spawn steam particles when lava and water touch. You can tweak the color, lifetime, and movement in these settings.
- **Emission Rate** - sets the spawn rate of particles when fluids mix. A lower emission rate means more particles will be spawned more quickly.

<a name="particle-generator"></a>
### Fluid Particle Generator
<sub>**This functionality is subject to future changes.**</sub>

The **Fluid Particle Generator** is a extension layer that uses data from the fluid simulation to generate particles. There are currently two types of particles, 

1. **Splash particles** which are generated at high turbulence and braking waves. These particles inherit the fluid simulation's velocity at spawn and continue the select trajectory until their life time expires
2. **Surface particles** which are generated at high turbulence. These particles are spawned on top of the fluid and advect/move with the fluid simulation's velocity. They can be rendered to a offscreen buffer to be read in the water shader as a foam mask.

#### Splash Particles

![Splash Particles](../../assets/images/fluidparticlegenerator_splash.png)

- **Breaking Waves** - emit splash particles when the fluid simulation meets the conditions for a breaking wave.
- **Steepness Threshold** - the steepness of the wave's slope required to be to emit a particle
- **Rise Rate Threshold** - the rising rate the wave requires to emit a particle.
- **Wave Length Threshold** - the length a wave needs to be to a emit a particle.
- **Breaking Wave Grid Stagger** - control the amount of frames between the update of each cell. A different cell will within a grid pattern will be selected each frame. This helps reduce the amount of particles being spawned each frame, requiring less particles while still analyzing the whole simulation.

- **Turbulence Splashes** - emit splashes where the fluid is more turbulent (diverging neighbouring velocities).
- **Splash Turbulence Threshold** - the amount of turbulence required before a splash particle spawns.
- **Turbulence Splash Grid Stagger** - control the amount of frames between the update of each cell. A different cell will within a grid pattern will be selected each frame. This helps reduce the amount of particles being spawned each frame, requiring less particles while still analyzing the whole simulation.

- **Layer** - the culling layer this particle system will be on, this can used for drawing the particles only to a specific camera.
- **Material** - the material use when rendering the particles. This material requires the shader ProceduralParticle or ProceduralParticleUnlit.
- **Max Particles** - The amount of particles to be allocated and can be active at one time. Increasing this number allows for more particles, but decreases performance.
- **Particle Properties** - the properties of the emitted particles. Control the color, velocity, acceleration and life range of the particles.

#### Surface Particles

![Surface Particles](../../assets/images/fluidparticlegenerator_surface.png)

- **Turbulence Surface** - Emit particles in turbulent fluids, these particles are advected by the fluid simulation's velocity field.
- **Surface Turbulence Threshold** - The amount of turbulence required before a surface particle spawns. 
- **Surface Grid Stagger** - Control the amount of frames between the update of each cell. A different cell will within a grid pattern will be selected each frame. This helps reduce the amount of particles being spawned each frame, requiring less particles while still analyzing the whole simulation.
- **Render Offscreen** - Render the surface particles to a offscreen buffer to be in the Water shader when this is enabled on the material.

- **Layer** - the culling layer this particle system will be on, this can used for drawing the particles only to a specific camera.
- **Material** - the material use when rendering the particles. This material requires the shader ProceduralParticle or ProceduralParticleUnlit.
- **Max Particles** - The amount of particles to be allocated and can be active at one time. Increasing this number allows for more particles, but decreases performance.
- **Particle Properties** - the properties of the emitted particles. Control the color, velocity, acceleration and life range of the particles.

<a name="fluid-rigidbody"></a>
### Fluid RigidBody

**Fluid RigidBody** is a component that can be applied to a GameObject to interact with the fluid simulation. It supports physics features like buoyancy, advection and creating waves. To simulate these effects **CPU Height Read** needs to be enabled.

![Fluid Rigidbody](../../assets/images/fluidrigidbody.png)

#### Waves

- **Create Waves** - enables the object to interact with the fluid simulation by creating waves in the direction the object is moving.
- **Wave Radius** - adjusts the size of the wave.
- **Wave Strength** - adjusts the height of the wave.
- **Wave Falloff** - adjusts the falloff curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create sharper/flatter wave/vortex shapes. Higher values mean a faster falloff.

#### Splashes
- **Create Splashes** - enables the object to interact with the fluid simulation by creating splashes when falling into the fluid.
- **Splash Force** - adjusts the force applied to the fluid simulation when the object lands in the fluid. Faster falling objects create bigger splashes.
- **Splash Radius** - adjusts the size of the splash.
- **Splash Time** - adjusts the time of the splash force being applied while surface contact is being made.
- **Splash Particles** - a list of ParticleSystems and overrides that will be spawned when the rigid body makes contacts with the fluid.
    - **System** - [ParticleSystem](https://docs.unity3d.com/ScriptReference/ParticleSystem.html) to be emitted when the [Rigidbody](https://docs.unity3d.com/6000.1/Documentation/Manual/class-Rigidbody.html) hits the fluid.
    - **Override Splash Particles** - Determines if the particle system's start velocity and emission are to be overwritten based on the Rigidbody's impact speed with the fluid.
    - **Splash Emission Rate** - Particle system emission rate when the rigidbody hits the fluid.
    - **Splash Particle Speed Scale** - Adjusts the start speed of the particles.

#### Physics

- **Advection Speed** - adjusts the influence the fluid simulation's velocity field has on the object. Higher values will move the object through the fluid at faster speeds.
- **Drag** - adjusts the amount of linear drag that is applied when the object is in contact with the fluid.
- **Angular Drag** - adjusts the amount of angular/rotational drag that is applied when the object is in contact with the fluid.
- **Buoyancy** - adjusts the buoyancy of the object. Higher values will make the object pushed up by the fluid more, causing it to float. Lower values will make objects float less, or even sink.

<a name="fluid-simulation-obstacle"></a>
### Fluid Simulation Obstacle
**Fluid Simulation Obstacle** is a component that can be added to any object to draw a **Renderer** or a procedural shape into the fluid simulation's heightmap automatically
The fluid will flow around or over this obstacle but cannot flow under it so it is advised to use this on those that are mainly round and do not create a convex shape with the terrain. 

![alt text](../../assets/images/fluidsimulationobstacle.png)

- **Mode** - select the rendering mode to use for this obstacles
    Options:
    - *Renderer* - automatically grab the attached *Renderer* component from the gameobject.
    - *Shape* - render a procedural shape based on the chosen size.
- **Shape** - the shape of the procedural object.
- **Radius** - the radius of the sphere/cylinder.
- **Length** - the length of the cylinder.
- **Size** - the size of the box.

<a name="fluid-simulation-event"></a>
### Fluid Event Trigger
**FluidEventTrigger** is a component that can be used to see if and when a object is in a region with fluid The most dominant/highest fluid will be reported. 

![alt text](../../assets/images/fluid_trigger_event.png)

- **onFluidEnter** - the event that will be triggered when fluid enters the trigger.
- **onFluidExit** - the event that will be triggered when fluid has left the trigger.
- **fluidLayer** - the current fluid layer at the location of this trigger.
- **fluidHeight** - the height of the fluid at the location of this trigger.
- **isInFluid** - is the trigger in fluid or not.

Adding the following functions to a script allows the them to be registered to the **OnFluidEnter** and **OnFluidExit** event as shown in the image above.
```c#
public void OnFluidEnter(FluidFrenzy.FluidEventTrigger evt)
{
    Debug.LogFormat("Fluid Layer {0} entered trigger {1} ", evt.name, evt.fluidLayer);
}
public void OnFluidExit(FluidFrenzy.FluidEventTrigger evt)
{
    Debug.LogFormat("Fluid Layer {0} exit trigger {1} ", evt.name, evt.fluidLayer);
}
```

---

<div style="page-break-after: always;"></div>

<a name="fluid-rendering-components"></a>
