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
### Fluid Simulation

**Fluid Simulation** is the core component of Fluid Frenzy. It handles the full simulation and the components attached to it.

![Fluid Simulation](../../assets/images/fluidsimulation.png)

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

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_0_0.png)

- **Run in Fixed Update** - allows the user to choose between simulating in *Update* or *Fixed Update*. It is recommended to run in *Fixed Update* for better stability, as the delta time will not fluctuate and the simulation will be in sync with Unity's physics. If your game is using a very high or low 'Time.fixedDeltaTime' value, it is advised to simulate in Update. The simulation will always run at a fixed timestep of 60hz to maintain stability, even if your framerate is higher or lower. This means that if you have a higher framerate, eventually there will be a frame where the simulation does not have to run. Conversely, with a lower framerate, the simulation will need to run multiple times per frame to catch up. This is because 2.5D Fluid simulations tend to become unstable with high timesteps.

#### Wave Simulation Settings

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_1_0.png)

These settings control the main part of the simulation, how fast fluids move down the terrain and around obstacles, how fast they dissolve and how high they get in certain regions.

- **Number Of Cells** - controls the number of cells/pixels the simulation will be using. It is recommended to use a power of 2 value like 512x512 or 1024x1024. The higher the value the more accurate the simulation gets, but also more expensive. 
- **Cell Size** - scales the size of each cell to control how fast the fluid flows, a smaller **Cell Size** means less fluid can exist in the cell resulting in faster flowing fluid.
- **Wave Damping** - controls how fast the waves and fluid should dampen down to no waves.
- **Acceleration** - controls the speed of the fluid. A higher value means the fluid will move faster.
- **Open Borders** - is used to allow the fluid to leave the simulation. When disabled the fluid will bounce off the borders of the simulation and accumulate over time. 

<sub>* Due to the 2.5D nature of the simulation each cell/pixel represents a world space size: `dimension / Number Of Cells`. This means scaling the number of cells up can cause the fluid to move slower in world space. The simulation tries to automatically scale as best as possible, but can only move so fast before becoming unstable. Therefore at some point making the **Cell Size** lower or **Acceleration** higher will have no effect, if you want your simulation to move faster you will have to reduce the **Number Of Cells**.</sub>

#### Rendering Settings

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_2_0.png)

- **Clip Height** - any fluid height below this value will be treated as no fluid. This is to help clipping issues due to floating point impression.

#### CPU>GPU Readback

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_3_0.png)

- **CPU Height Read** - the simulation fully runs on the GPU but in some cases, interaction with objects that live in the CPU is desired like floating objects. When enabling this the height and velocity will be read back to the CPU asynchronously. The reason it is readback asynchronously is to prevent stalls and improve performance, this does mean that the CPU data is a few frames behind the GPU simulation.
- **Time Slicing** - to improve the performance further time slicing of the *readback* can be enabled. The selected value means how many *readbacks* will need to be done to get the full simulation back to the CPU. The higher this number, the less expensive the *readback* becomes but the longer it takes before the simulation is fully read back. Time slicing happens from top to bottom of the simulation, meaning the 100/N% in the height will be read back. Only one *readback* per simulation is performed at the same time so the next timeslice section will not start until the previous one is finished.

#### Velocity Field Settings

These settings control the behavior of the Velocity Field. The Velocity Field is a 2D texture used for effects like flow mapping, foam advection, erosion, and sediment advection of eroded materials. It is generated from inputs from outputs generated by the Wave Simulation.

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_4_0.png)

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

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_5_0.png)

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

![Foam settings](../../assets/images/foamsettings.png)

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

![Flow mapping settings](../../assets/images/flowmappingsettings.png)

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

![Erosion Layer](../../assets/images/erosionlayer.png)

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

![Terraform Layer](../../assets/images/terraformlayer.png)

- **Fluid Mixing** - enables/disables fluid mixing of multi-layered fluid simulations. When enabled two fluids occupying the same cell will start mixing together. In the case of this simulation mixing of water and lava occurs by turning the fluids into rocky terrain.
- **Mix Rate** - the rate at which the fluids mix. Higher values mean faster mixing.
- **Mix Scale** - scales the amount of terrain to be added when two fluids mix. You can use this value if you want to have more or less terrain added when fluids mix. **Mix Scale** 1 means for every unit of fluid being mixed, the same amount is added to the terrain. Any **Mix Scale** below 1 causes fewer units of terrain will be added, any **Mix Scale** higher than 1 causes more units of terrain to be added.
- **Deposit Rate** - the rate at which terrain height from mixed fluids is added to the terrain heightmap.
- **Fluid Particles** - the behavior and visual control of the particles that spawn when fluids mix. This is used to spawn steam particles when lava and water touch. You can tweak the color, lifetime, and movement in these settings.
- **Emission Rate** - is the spawn rate of particles when fluids mix. A higher emission rate means more particles will be spawned.

<a name="fluid-rigidbody"></a>
### Fluid RigidBody

**Fluid RigidBody** is a component that can be applied to a GameObject to interact with the fluid simulation. It supports physics features like buoyancy, advection and creating waves. To simulate these effects **CPU Height Read** needs to be enabled.

![Fluid Rigidbody](../../assets/images/fluidrigidbody.png)

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
