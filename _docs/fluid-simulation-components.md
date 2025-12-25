---
title: Fluid Simulation Components
permalink: /docs/fluid_simulation_components/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

This section covers all the simulations and the modification components Fluid Frenzy has to offer.

There are two types of simulations: **Flux Fluid Simulation** and **Flow Fluid Simulation**. Both simulations handle the full simulation and the components attached to it using a different method. The user can choose which to simulation to use in their scene depending on which is more suitable for their needs. 

<a name="fluid-simulation"></a>
### Fluid Simulation

[Fluid Simulation](#fluid-simulation) is the core component of Fluid Frenzy. It handles the full simulation and the components attached to it.

This is the base class for all fluid simulation types ([Flux Fluid Simulation](#flux-fluid-simulation) and [Flow Fluid Simulation](#flow-fluid-simulation)). The system uses the `Shallow Water Equations` to create a physically-based `fluid heightfield simulation`. This core technology calculates a velocity field that dictates how the fluid moves and flows over a static, underlying ground heightfield, providing a realistic and performant simulation of large water bodies. It defines common properties and systems used by both solvers.  

![Fluid Simulation](../../assets/images/fluidsimulation.png)

#### Terrain and Obstacle Input

 The simulation's bottom depth and its interaction with static terrain are managed through a single primary input source. You must select one of the following modes to define the simulation floor, as they are mutually exclusive:   
- `UnityTerrain` (Uses the standard Unity Terrain component) 
- `Simple/TerraformTerrain` (A custom, simplified terrain for faster results) 
- `Orthographic layer capture` (Captures scene geometry from a camera view) 
- `Custom heightmap` (Uses a texture as the terrain height input) 
- `MeshCollider` (Can be used as a simple, static bottom surface if no other base mode is selected)  

Additionally, `FluidObstacle` components can be added to the scene to represent dynamic or static objects that interact with the fluid surface, compatible with any of the primary base modes. 

#### Boundary Conditions

 The simulation handles the outer edges of the simulation grid realistically for various scene types:   
-  **Reflective Boundaries**  The grid boundary forces water to reflect back into the simulation, ideal for enclosed areas like pools or tanks.  
-  **Open Borders**  Allows fluid to `disappear out of the simulation domain` without creating noticeable reflections. This is essential for simulating an open ocean or a river with continuous flow.

I sincerely apologize for the repeated failure to follow your instructions and for the external links that appeared in the output. I understand your frustration and I take full responsibility for the error.

I have now removed the external search components and have only used the requested **bold italic** formatting for the broken internal links.

Here is the final, corrected table, without any external search or links:

| Property | Description |
| :--- | :--- |
| Terrain Type | Defines the different base ground sources the fluid simulation can use to determine the terrain height. |
| [Settings](#fluid-simulation-settings) | The [Fluid Simulation Settings](#fluid-simulation-settings) asset that controls the core physical parameters and resolution of the simulation.<br/><br/>Most settings within the asset can be modified at runtime and automatically update the simulation. However, assigning an entirely new settings instance will require the simulation's compute resources to be completely recreated. |
| Group ID | Specifies the grouping ID for this [Fluid Simulation](#fluid-simulation). This is used to automatically identify and connect with neighbouring simulations that share the same ID. |
| Grid Pos | Specifies the grid position of this simulation within a tiled setup. This is used, along with ***Group ID***, to gather and manage neighbouring [Fluid Simulation](#fluid-simulation) |
| Dimension Mode | Selects the method used to determine the world-space ***Dimension*** and ***Cell World Size*** of the simulation.<br/><br/>-  **`Bounds`**  The user sets the total world-space ***Dimension***. The ***Cell World Size*** is then automatically calculated based on the number of cells in the settings.  <br/>-  **`CellSize`**  The user sets the size of a single cell (***Cell World Size***). The total world-space ***Dimension*** is then automatically calculated based on the number of cells in the settings. |
| Dimension | The total world-space size (X and Z) of the fluid simulation domain.<br/><br/>This dimension is critical for several components:  <br/>-  **Fluid Renderer**  Determines the size of the rendered surface mesh.  <br/>-  **Fluid Simulation**  Scales the behaviour of the fluid (e.g., speed and wave height) to ensure physical consistency regardless of the simulation's size. |
| Cell World Size | The world-space size of a single cell (or pixel) in the fluid simulation grid.<br/><br/>This value is either user-defined ***Cell World Size*** or automatically calculated ***Bounds***. A smaller value increases resolution but reduces performance. |
| Initial Fluid Height | Specifies the uniform fluid height at the start of the simulation.<br/><br/>This value defines the initial water *depth* relative to the terrain height at that point. Specifically, it's the target initial Y-coordinate for the fluid surface. Any terrain geometry below this Y-coordinate will be submerged. |
| Initial Fluid Height Texture | A texture mask that specifies a non-uniform initial fluid height across the domain.<br/><br/>This acts as a heightmap, where bright pixels correspond to a higher initial fluid level. The final initial fluid height for any pixel is the maximum of the value sampled from this texture and the uniform ***Initial Fluid Height***. |
| Fluid Base Height | A normalized offset (from 0 to 1) applied to the fluid's base height.<br/><br/>This subtle adjustment can be used to prevent visual clipping artifacts that may occur between the fluid surface and underlying tessellated or displaced terrain geometry. |
| Terrain Type | Specifies which type of scene geometry or data source to use as the base ground for fluid flow calculations.<br/><br/>-  ***Unity Terrain***   Use a standard ***Unity Terrain*** assigned to the ***Unity Terrain*** field.   <br/>-  ***Simple Terrain***   Use a custom terrain component (e.g., `SimpleTerrain` or `TerraformTerrain`) assigned to the ***Simple Terrain*** field.   <br/>-  ***Heightmap***   Use a `Texture2D` as a heightmap assigned to the ***Texture Heightmap*** field. This is useful for custom terrain systems.  <br/>-  ***Mesh Collider***   Use a static ***Mesh Collider*** assigned to the ***Mesh Collider*** field as the base ground.  <br/>-  ***Layers***   Generate the base heightmap by capturing layers via a top-down orthographic render. |
| Unity Terrain | Assign a ***Unity Terrain*** to be used as the simulation's base ground when ***Terrain Type*** is ***Unity Terrain***. |
| [Simple Terrain](../terrain#simple-terrain) | Assign a custom terrain component, such as `SimpleTerrain` or `TerraformTerrain`, to be used as the base ground when ***Terrain Type*** is ***Simple Terrain***. |
| Texture Heightmap | Assign a heightmap `Texture2D` to be used as the simulation's base ground when ***Terrain Type*** is ***Heightmap***. |
| Heightmap Scale | A global multiplier applied to the sampled height values from the ***Texture Heightmap***. |
| Mesh Collider | Assign a ***Mesh Collider*** component to be used as the simulation's base ground when ***Terrain Type*** is ***Mesh Collider***. |
| Capture Layers | A layer mask used to filter which scene objects are captured when ***Terrain Type*** is ***Layers***. |
| Capture Height | The vertical extent, measured in world units, for the top-down orthographic capture when ***Terrain Type*** is ***Layers***.<br/><br/>The orthographic render captures geometry from the simulation object's Y position up to `transform.position.y + captureHeight`. |
| Update Ground Every Frame | If true, the simulation re-samples the underlying geometry (Unity Terrain, Meshes, Layers, or Colliders) every frame. <br/>Enable this if your ground surface is deforming or moving during the simulation. |
| ***Extension Layers*** | A list of optional ***Fluid Layer*** extensions (e.g., `FoamLayer`, `FluidFlowMapping`) that should be executed and managed by this fluid simulation. |
| [Collider Properties](../physics_colliders#collider-properties) | Properties used to control the generation and configuration of the ***Mesh Collider*** representing the fluid surface.<br/><br/>These settings determine the physical shape and properties of the fluid's surface when interacting with objects via Unity's physics system. |
| Dimension Mode | Choose how the dimenions of the fluid simulation and renderer should be calculated. |
| Simulation Type | Returns which simulation type this object is. |
| Boundary Sides | Defines the sides of the simulation domain used for boundary conditions and tiling neighbors. |
| [Neighbours](#fluid-simulation) | An array storing references to the four neighboring [Fluid Simulation](#fluid-simulation) instances in a tiled setup.<br/><br/>The array is indexed based on the ***Boundary Sides*** enum order (Left, Right, Bottom, Top). This is automatically populated when using the Tiled Simulation Gizmos or can be set manually in the Inspector. |

<a name="fluid-simulation-settings"></a>
### Fluid Simulation Settings

This is the abstract base class for all simulation settings, serving as a [Scriptable Object](#scriptable-object) asset assigned to a [Fluid Simulation](#fluid-simulation). It defines the essential, global properties shared across all fluid simulation types.

By utilizing a [Scriptable Object](#scriptable-object) asset, `FluidSimulationSettings` simplifies the configuration workflow. This approach allows a single settings profile to be reused and instantly modified across multiple [Fluid Simulation](#fluid-simulation) components within a project, ensuring consistent simulation behavior.  

#### Creation

 To create a new simulation settings asset, navigate to: `Assets > Create > Fluid Frenzy > Simulation Settings`.  

#### Properties

 This base class contains all parameters and properties that are universal to the core fluid heightfield simulation system, independent of the specific solver (e.g., Flux, Flow). Any specialized settings for a particular solver will be defined in classes that derive from `FluidSimulationSettings`.

##### Wave Simulation

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_1_0.png)

| Property | Description |
| :--- | :--- |
| Number of Cells | Controls the resolution (width and height) of the simulation's 2D grid.<br/><br/>It is highly recommended to use power-of-two dimensions (e.g., 512x512 or 1024x1024) for optimal GPU performance. A higher resolution increases the spatial accuracy of the fluid simulation but linearly increases both GPU memory usage and processing cost (frame time). |
| Cell Size Scale | Adjusts the internal scale factor of the fluid volume within each cell to control the effective flow speed.<br/><br/>A smaller `cellSize` implies less fluid volume per cell, which results in faster-flowing fluid and more energetic wave behavior for a given acceleration. |
| Wave Damping | Adjusts the rate at which wave energy is dissipated (dampened) over time.<br/><br/>A higher value causes waves and ripples to fade away quickly, leading to a calmer surface, while a lower value allows waves to persist longer. |
| Acceleration | The force of gravity or acceleration applied to the fluid, which directly controls the speed of wave propagation.<br/><br/>This value simulates the effect of gravity (9.8 m/s² is typical) on the fluid and is the primary factor determining how quickly waves travel across the simulation domain. |
| Open Borders | Determines whether fluid is allowed to leave the simulation domain at the boundaries.<br/><br/>When disabled, the boundaries act as solid walls, causing fluid to reflect and accumulate over time. When enabled, fluid passing over the border is removed, which maintains fluid consistency but causes a net loss of volume. |

<sub>* Due to the 2.5D nature of the simulation each cell/pixel represents a world space size: `dimension / Number Of Cells`. This means scaling the number of cells up can cause the fluid to move slower in world space. The simulation tries to automatically scale as best as possible, but can only move so fast before becoming unstable. Therefore at some point making the **Cell Size** lower or **Acceleration** higher will have no effect, if you want your simulation to move faster you will have to reduce the **Number Of Cells**.</sub>

##### Rendering

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_2_0.png)

| Property | Description |
| :--- | :--- |
| Clip Height | A minimum fluid height threshold below which a cell is considered to have no fluid.<br/><br/>This value is primarily used to prevent minor visual artifacts or "clipping" issues that can arise from floating-point imprecision when a cell's fluid height is extremely close to zero. Any cell below this height is treated as empty. |

##### GPU > CPU Readback Synchronization

![Fluid Simulation Settings](../../assets/images/fluidsimulationsettings_slice_3_0.png)
The simulation fully runs on the GPU but in some cases, interaction with objects that live in the CPU is desired like floating objects. When enabling this the simulation data for height and velocity will be read back to the CPU asynchronously. The reason the simulation data is readback asynchronously is to prevent stalls and improve performance, this does mean that the CPU data is a few frames behind the GPU simulation.

| Property | Description |
| :--- | :--- |
| Readback Height & Velocity | Enables asynchronous readback of the simulation's height and velocity data from the GPU to the CPU.<br/><br/>This is necessary for CPU-side interactions, such as buoyancy, floating objects, or gameplay logic that requires current fluid data. Since the readback is asynchronous to prevent performance stalls, the CPU data will lag behind the GPU simulation by a few frames. |
| Timeslicing | The number of frames over which the CPU readback of the simulation data is sliced to spread the performance cost.<br/><br/>Time slicing divides the data transfer into smaller chunks over multiple frames. A higher value reduces the cost per frame but increases the total latency before the full simulation data is available on the CPU. The readback processes the simulation data vertically (from top to bottom). |
| Readback Distance Field | Enables the asynchronous generation and readback of a distance field representing the nearest fluid location.<br/><br/>The distance field is generated on the GPU using the Jump Flood algorithm and then transferred to the CPU. This data provides the distance to the nearest fluid cell, which is useful for advanced gameplay logic or visual effects. Due to the asynchronous nature of the readback, the CPU data will lag behind the GPU simulation. |
| Downsample | The downsampling factor applied to the distance field's resolution.<br/><br/>Increasing this value improves performance by reducing the GPU generation and CPU transfer time, but it decreases the spatial accuracy of the distance field. A value of 0 means no downsampling. |
| Iterations | The number of internal steps the Jump Flood algorithm performs to generate the distance field.<br/><br/>Lowering this number increases performance but reduces the accuracy, particularly for larger distances within the field. Higher resolution distance fields generally require more iterations for full accuracy. |
| Distance Field Time Slice Frames | The number of frames over which the distance field's CPU readback is sliced to spread the performance cost.<br/><br/>Similar to **Read Back Time Slice Frames**, this value balances transfer cost per frame against the overall latency of the data becoming available on the CPU. |

##### Evaporation

| Property | Description |
| :--- | :--- |
| Linear Evaporation | The rate of constant (linear) fluid volume removal from every cell in the simulation.<br/><br/>This simulates a constant, external water loss like pumping. The fluid volume is reduced uniformly at this rate: `fluid -= linearEvaporation * dt`. |
| Proportional Evaporation | The rate of fluid volume removal proportional to the amount of fluid currently in the cell.<br/><br/>This simulates natural evaporation, where the rate is dependent on surface area/volume. More fluid results in a higher removal rate: `fluid -= fluid * proportionalEvaporation * dt`. |

#### Second Layer

| Property | Description |
| :--- | :--- |
| Second Layer | Enables an optional secondary layer for simulating a different type of fluid.<br/><br/>The secondary layer runs concurrently with the main fluid layer, increasing VRAM usage and slightly decreasing performance. However, this is generally more efficient than running a separate `FluidSimulation` component. The second layer is used for features like **Lava** in the Terraform simulation option. The following properties provide independent physics overrides for this layer. |
| Cell size | Secondary Layer: Adjusts the internal scale factor of the fluid volume to control the effective flow speed.<br/><br/>A smaller `cellSize` implies less fluid volume per cell, which results in faster-flowing fluid and more energetic wave behavior for a given acceleration. |
| Wave Damping | Secondary Layer: Adjusts the rate at which wave energy is dissipated over time.<br/><br/>A higher value causes waves and ripples to fade away quickly, leading to a calmer surface, while a lower value allows waves to persist longer. |
| Acceleration | Secondary Layer: The force of acceleration applied to the fluid, which directly controls the speed of wave propagation.<br/><br/>This value simulates the effect of gravity (9.8 m/s² is typical) on the fluid and is the primary factor determining how quickly waves travel across the simulation domain. |
| Linear Evaporation | Secondary Layer: The rate of constant (linear) fluid volume removal.<br/><br/>Fluid volume is reduced uniformly at this rate: `fluid -= secondLayerLinearEvaporation * dt`. |
| Proportional Evaporation | Secondary Layer: The rate of fluid volume removal proportional to the amount of fluid currently in the cell.<br/><br/>More fluid results in a higher removal rate: `fluid -= fluid * secondLayerProportionalEvaporation * dt`. |

<a name="flux-fluid-simulation"></a>
### Flux Fluid Simulation

[Flux Fluid Simulation](#flux-fluid-simulation) is the core component of Fluid Frenzy. It handles the full simulation and the components attached to it.

The `FluxFluidSimulation` uses a Flux-based algorithm, often referred to as the **Pipe Model**, to simulate large water bodies. This approach directly calculates the volume exchange (flux) between grid cells, resulting in a highly stable simulation capable of generating very smooth, realistic waves.  

#### The Pipe (Flux) Model
 
 In this model, the fluid domain is discretized into a grid of `vertical columns`. These columns interact with their four neighbors via `virtual pipes`. The simulation determines the flow (flux) through these pipes by calculating the difference in pressure (based on fluid level) between adjacent columns. This method of modeling volume exchange guarantees mass conservation and smooth waves.  

#### Simulation Characteristics

  The system provides the following trade-offs compared to other simulation types:  

| Pros | Cons |
| :--- | :--- |
| Stable at any height. | Higher performance cost. |
| Smoother waves. | Higher VRAM usage. |
| Allows for more complex velocity solving (e.g., vortices). | Decoupled Wave/Velocity: The velocity field is derived from the outflow, causing it to lag behind abruptly changing waves. |
| Control waves and flow mapping separately. |  |

<a name="flux-fluid-simulation-settings"></a>
### Flux Fluid Simulation Settings

Represents the specialized settings for the [Flux Fluid Simulation](#flux-fluid-simulation) solver. This class extends [Fluid Simulation Settings](#fluid-simulation-settings) to include specific properties and parameters unique to the Flux simulation algorithm.

As a [Scriptable Object](#scriptable-object) asset, `FluxFluidSimulationSettings` allows for the reuse and quick modification of a specific Flux simulation profile across multiple [Flux Fluid Simulation](#flux-fluid-simulation) components. This ensures consistency and simplifies rapid iteration on simulation characteristics.  

#### Creation

  To create a new Flux-specific simulation settings asset, navigate to: `Assets > Create > Fluid Frenzy > Flux > Simulation Settings`.  

#### Specialized Flux Properties

 This asset contains all settings that are specific to the "Flux" implementation of the fluid solver, inheriting all universal properties from the base [Fluid Simulation Settings](#fluid-simulation-settings). These properties are used to control the unique behaviors, stability, and optimizations of the Flux algorithm.

| Property | Description |
| :--- | :--- |
| Additive Velocity | Controls whether the newly calculated velocity for the current frame is added to or overwrites the previous frame's velocity.<br/><br/>-  **Enabled (Additive)**  The current frame's velocity is accumulated onto the existing velocity map. This is essential for simulating persistent effects like continuous flow, pressure buildup, and rotational momentum (swirls/eddies).  <br/>-  **Disabled (Overwrite)**  The velocity map is reset each frame to only contain the velocity calculated from the fluid's movement during that single frame. This typically results in a less continuous, more reactive flow. |
| Velocity Texture Size | Controls the resolution (width and height) of the internal Velocity Field texture.<br/><br/>This texture stores the flow direction and magnitude used for advection. The resolution is often lower than the main fluid grid to save memory and processing time. |
| Padding Percentage | A percentage of padding added to the borders of the velocity flow map.<br/><br/>This padding is specifically designed for use in tiled fluid simulations (currently in **beta**) to ensure smooth flow continuity between adjacent tiles. It should typically be set to 0 if tiling is not used. |
| Advection Scale | Scales the distance the velocity field advects (carries) itself and other data maps like the [Foam Layer](#foam-layer).<br/><br/>A larger value causes the flow patterns, foam, and dynamic flow mapping data to be carried further by the fluid movement each frame, effectively increasing the visual influence of the velocity field. |
| Advection Iterations | Determines the number of Jacobi iterations used to solve for the fluid's pressure field (the incompressible part of the velocity).<br/><br/>This step is crucial for fluid incompressibility. Increasing the iterations improves the accuracy of the pressure solution and reduces volume loss but increases the computational cost. The default value of 5 is generally recommended for visual quality. |
| Velocity Damping | Scales down the accumulated velocity of the fluid each frame to slow down movement when no new acceleration is applied.<br/><br/>This damping acts as a friction or viscosity factor. Higher values dampen the velocity faster, causing the fluid to come to rest more quickly. |
| Velocity Scale | The factor by which the newly generated fluid velocity (outflow) is applied to the final velocity map texture.<br/><br/>This value controls the responsiveness and maximum speed of the flow. A higher scale means the fluid accelerates faster, resulting in more pronounced and quickly-appearing flow patterns. |
| Velocity Max | Clamps the magnitude of the velocity field vector to a maximum value.<br/><br/>This prevents the fluid from accelerating past a defined maximum speed, which helps maintain numerical stability and controls the intensity of the flow. |
| Pressure | Scales the perceived incompressibility of the fluid's velocity field when solving for pressure.<br/><br/>A higher value forces the fluid to "push out" more aggressively to neighboring cells. Tweaking this value significantly influences the size and intensity of swirls/eddies and the pressure buildup around obstacles. |
| Additive Velocity | Secondary Layer: Controls whether the newly calculated velocity is added to or overwrites the previous frame's velocity.<br/><br/>-  **Enabled (Additive)**  The current frame's velocity is accumulated onto the existing velocity map. This is essential for simulating persistent effects like continuous flow, pressure buildup, and rotational momentum (swirls/eddies).  <br/>-  **Disabled (Overwrite)**  The velocity map is reset each frame to only contain the velocity calculated from the fluid's movement during that single frame. This typically results in a less continuous, more reactive flow. |
| Velocity Scale | Secondary Layer: The factor by which the newly generated fluid velocity is applied to the final velocity map texture.<br/><br/>This value controls the responsiveness and maximum speed of the flow. A higher scale means the fluid accelerates faster, resulting in more pronounced and quickly-appearing flow patterns. |
| Use Custom Viscosity | Enables a custom viscosity control model for the second fluid layer.<br/><br/>When enabled, this feature allows the second fluid to flow more slowly on shallow slopes and stack up to a certain height before flowing, which is useful for simulating highly viscous fluids like lava. |
| Viscosity | Scales the flow speed of the second layer when **Second Layer Custom Viscosity** is enabled.<br/><br/>This factor determines the fluid's viscosity. The fluid volume leaves the cell at a slower rate than its calculated velocity, simulating thicker fluid. A higher value results in more viscous, slower flow. |
| Flow Height | Indicates the minimum height (thickness) the second layer fluid must achieve before it begins to flow significantly on flat or near-flat surfaces.<br/><br/>This simulates the non-Newtonian behavior of highly viscous fluids like lava, where an initial minimum head height is required to overcome internal friction before flow commences. |

### Flow Fluid Simulation

[Flow Fluid Simulation](#flow-fluid-simulation) is the core component of Fluid Frenzy. It handles the full fluid simulation based on the 2D Shallow Water Equations (SWE) approach for large bodies of water.

The `FlowFluidSimulation` leverages the **Shallow Water Equations (SWE)** to simulate large water bodies such as rivers, lakes, and oceans by treating the fluid as a 2D height field. This velocity-based model is computationally efficient, allowing for real-time performance and multiple simulation iterations per frame.

#### The 2D Height Field Model

The simulation models large bodies of water (like rivers, lakes, and oceans) using a highly efficient `2D Height Field`. This model is a streamlined version of full 3D fluid dynamics, designed for fast, real-time performance. It tracks two main components across a grid: the `Height Field` (`h`), which manages the overall water level, and the `Horizontal Velocity Field` (`v`), which controls the direction and speed of the flow. This approach is key to capturing realistic horizontal phenomena like strong river currents, swirling whirlpools, and how objects are pushed by the flow-features that simpler wave simulations miss.

#### Performance and Stability

The solver is built for maximum speed and runs on a `Fixed Timestep`. To maintain accuracy and stability regardless of the rendering frame rate, the simulation employs several techniques:

 
- **Adaptive Stepping** 
 The simulation will run multiple times per frame to catch up if the frame rate drops, or skip a frame if the frame rate is higher than the simulation's fixed timestep.
 
 
- **Clamping** 
 Limits the water's maximum flow speed and ensures the water level never dips below the terrain (`h >= 0`). This is vital for stability, especially in dynamic, high-energy water scenes.
 
 
- **Overshooting Reduction** 
 Automatically detects and smooths out unnatural wave artifacts that appear when large waves transition too quickly into shallow areas, making breaking waves look more convincing.


<a name="flow-fluid-simulation-settings"></a>
### Flow Fluid Simulation Settings

Represents the specialized settings for the [Flow Fluid Simulation](#flow-fluid-simulation) solver. This class extends [Fluid Simulation Settings](#fluid-simulation-settings) to include specific properties and parameters unique to the Flow simulation algorithm.

As a [Scriptable Object](#scriptable-object) asset, `FlowFluidSimulationSettings` allows for the reuse and quick modification of a specific Flow simulation profile across multiple [Flow Fluid Simulation](#flow-fluid-simulation) components. This ensures consistency and simplifies rapid iteration on simulation characteristics.  

#### Creation
 
 To create a new Flow-specific simulation settings asset, navigate to: `Assets > Create > Fluid Frenzy > Flow > Simulation Settings`.  

#### Specialized Flow Properties

 This asset contains all settings that are specific to the "Flow" implementation of the fluid solver, building upon the universal properties inherited from the base [Fluid Simulation Settings](#fluid-simulation-settings). These properties control the unique behaviors and optimizations of the Flow algorithm.

| Property | Description |
| :--- | :--- |
| Max Acceleration | Clamps the magnitude of the fluid's acceleration to a maximum value per frame.<br/><br/>Limiting acceleration is a stability measure, as it prevents sudden, large forces from being applied to the fluid. This helps control the rate at which fluid speed changes and improves the overall stability of the simulation. |
| Max Velocity | Clamps the magnitude of the velocity field vector to a maximum value.<br/><br/>This prevents the fluid from accelerating past a defined maximum speed, which helps maintain numerical stability and controls the intensity of the flow. |
| Overshooting Reduction | Enables a technique to mitigate the amplification of wave heights that can occur when waves transition from deep to shallow water.<br/><br/>This feature prevents "spiking" artifacts from appearing at the edges of waves, particularly in areas of rapid depth change, by applying a necessary correction factor. |
| Overshooting Edge | A threshold that determines the sensitivity for detecting a significant change in wave height (a "wave edge") as the fluid transitions into shallow areas.<br/><br/>A lower value makes the reduction system more sensitive, applying the correction to smaller wave changes. |
| Overshooting Scale | A scaling factor that adjusts the magnitude of the correction applied to reduce overshooting at detected wave edges.<br/><br/>This controls how aggressively the "spiking" artifacts are dampened. A higher value results in a stronger smoothing effect. |
| Max Acceleration | Secondary Layer: Clamps the magnitude of the second fluid layer's acceleration to a maximum value per frame.<br/><br/>Limiting acceleration is a stability measure, as it prevents sudden, large forces from being applied to the fluid. This helps control the rate at which fluid speed changes and improves the overall stability of the simulation. |
| Max Velocity | Secondary Layer: Clamps the magnitude of the second fluid layer's velocity vector to a maximum value.<br/><br/>This prevents the fluid from accelerating past a defined maximum speed, which helps maintain numerical stability and controls the intensity of the flow. |

<div style="page-break-after: always;"></div>
___

<a name="foam-layer"></a>
### Foam Layer

[Foam Layer](#foam-layer) is an [Fluid Layer](#fluid-layer) that can be attached to the [Fluid Simulation](#fluid-simulation). It generates a foam map based on the current state of the [Fluid Simulation](#fluid-simulation). There are several inputs from the [Fluid Simulation](#fluid-simulation) that are used to generate this map (Pressure, Y Velocity, and Slope). The influence of each of these inputs can be controlled by the [Foam Layer Settings](#foam-layer-settings). Note: This component lives on a GameObject but also needs to be added to the Layers list of the Fluid Simulation.

| Property | Description |
| :--- | :--- |
| [Settings](#foam-layer-settings) | The [Foam Layer Settings](#foam-layer-settings) that this [Foam Layer](#foam-layer) will use to generate it's foam mask. |

<a name="foam-layer-settings"></a>
### Foam Layer Settings

A [Scriptable Object](#scriptable-object) asset containing configuration parameters for a [Foam Layer](#foam-layer).

Using a settings asset allows for easy reuse and centralized modification of foam behaviors across multiple [Foam Layer](#foam-layer) instances. 

 To create a new settings asset, navigate to: `Assets > Create > Fluid Frenzy > Foam Layer Settings`.

![Foam settings](../../assets/images/foamsettings.png)

#### Foam Render Settings

| Property | Description |
| :--- | :--- |
| Texture Size | The resolution of the generated foam mask texture.<br/><br/>Higher resolutions provide sharper foam details but require more memory and GPU processing power. It is generally recommended to match the aspect ratio of the fluid simulation grid. |

#### Foam Decay Settings

| Property | Description |
| :--- | :--- |
| Exponential Decay Rate | The rate at which pressure-based foam decays exponentially per frame.<br/><br/>Higher values cause the foam to dissipate more rapidly. This affects foam generated by the pressure system. |
| Linear Decay Rate | The constant amount of pressure-based foam subtracted from the mask per frame (Linear Decay). |

#### Foam Pressure Settings

| Property | Description |
| :--- | :--- |
| Apply Pressure Foam | Toggles the generation of foam based on internal fluid pressure.<br/><br/>Note: This feature is strictly for use with [Flux Fluid Simulation](#flux-fluid-simulation). The alternative [Flow Fluid Simulation](#flow-fluid-simulation) does not calculate internal pressure fields, so enabling this will have no effect in that mode. |
| Pressure Range | Defines the pressure threshold range for foam generation.<br/><br/>-  **X (Min)**  Pressure values below this threshold generate no foam.  <br/>-  **Y (Max)**  Pressure values above this threshold generate the maximum amount of foam.   Intermediate values are interpolated using Smoothstep. |
| Pressure Increase Amount | The rate at which foam accumulates per frame when fluid pressure exceeds the [Pressure Range](#pressure-range) minimum. |

#### Foam Wave Settings

| Property | Description |
| :--- | :--- |
| Apply Wave Foam | Toggles the generation of foam based on wave geometry (height and steepness).<br/><br/>This system simulates whitecaps and crest foam caused by turbulent or high-amplitude waves. |
| Wave Angle Range | Defines the wave surface angle (steepness) thresholds for foam generation.<br/><br/>-  **X (Min)**  Wave angles below this value generate no foam.  <br/>-  **Y (Max)**  Wave angles above this value generate maximum foam.   Intermediate values are interpolated using Smoothstep. |
| Wave Angle Increase Amount | The amount of foam added per frame when the wave angle exceeds the [Wave Angle Range](#wave-angle-range) minimum. |
| Wave Height Increase Amount | The amount of foam added per frame based on the vertical (Y) velocity of the fluid surface.<br/><br/>This simulates foam generated by rapidly rising water, such as splashes or chaotic wave peaks. |

#### Shallow Foam Settings

| Property | Description |
| :--- | :--- |
| Apply Shallow Foam | Toggles the generation of foam in shallow water areas where fluid velocity is high.<br/><br/>This is useful for simulating shorelines or river rapids where water churns against the ground. |
| Shallow Foam Amount | The maximum intensity of foam added when the shallow water criteria are met. |
| Shallow Velocity Range | Defines the velocity range required to generate foam in shallow water.<br/><br/>-  **X (Min)**  Fluid speeds below this value generate no foam, even if the water is shallow.  <br/>-  **Y (Max)**  Fluid speeds above this value generate maximum foam.   Intermediate values are interpolated using Smoothstep. |
| Shallow Depth | The depth threshold for shallow water foam.<br/><br/>Foam will only be generated in areas where the fluid depth is less than this value (and velocity requirements are met). |

#### Turbulence Foam Settings

| Property | Description |
| :--- | :--- |
| Apply Turbulence Foam | Toggles the generation of foam based on velocity gradients (turbulence).<br/><br/>Calculates foam based on the curl or difference in velocity vectors between adjacent cells. |
| Turbulence Foam Amount | The intensity multiplier for foam generated by turbulence. |
| Turbulence Foam Threshold | The minimum turbulence value required to begin generating foam. |

___

<a name="flowmapping"></a>
### Fluid Flow Mapping

**Fluid Flow Mapping** is an extension layer that enables and controls [*flow mapping*](https://catlikecoding.com/unity/tutorials/flow/directional-flow/) functionality in the simulation and rendering side of Fluid Frenzy. The layer generates the *flow map* procedurally using the flow of the fluid simulation. The rendering data is automatically passed to the material assigned to the [Fluid Renderer](#fluid-rendering-components). There are several settings to control the visuals of the flow mapping in the layer which can be set in the [Fluid Flow Mapping Settings](#flowmap-settings) asset assigned to this layer.

- **Settings** - a [Fluid Flow Mapping Settings](#flowmap-settings) asset which holds the settings to be used for this Flow Mapping Layer

<a name="flowmap-settings"></a>
### Fluid Flow Mapping Settings

A [Scriptable Object](#scriptable-object) asset containing configuration parameters for [Fluid Flow Mapping](#fluid-flow-mapping).

Using a settings asset allows for easy reuse and centralized modification of flow mapping behaviors across multiple simulation instances. 

 To create a new settings asset, navigate to: `Assets > Create > Fluid Frenzy > Flow Mapping Settings`.

 ![Flow mapping settings](../../assets/images/flowmappingsettings.png)

| Property | Description |
| :--- | :--- |
| Flow Mapping Mode | Defines the technique used to render the fluid's surface flow and texture advection.<br/><br/>-  **`Off`**  No flow mapping is applied.  <br/>-  **`Static`**  Flow mapping is performed directly in the shader by offsetting UV coordinates based on the instantaneous velocity field.  <br/>-  **`Dynamic`**  Utilizes a separate simulation buffer to calculate UV offsets. The UVs are advected over time, similar to the velocity field and foam mask. This allows for complex swirling effects but may accumulate distortion over longer periods. |
| Flow Speed | A multiplier applied to the velocity vectors when calculating UV offsets.<br/><br/>Higher values create the appearance of faster-moving fluid but increase the visual distortion (stretching) of the surface texture. |
| Flow Phase Speed | Controls the frequency at which the flow map cycle resets to its original UV coordinates.<br/><br/>Continuous advection eventually distorts textures beyond recognition. To prevent this, the system resets the UVs periodically. <br/><br/> Increasing this value makes the reset occur more frequently, reducing maximum distortion. To hide the visual "pop" during a reset, the texture is sampled multiple times with offset phases and blended based on this cycle speed. |

___

<a name="erosion-layer"></a>
### Erosion Layer

![Erosion Layer](../../assets/images/erosionlayer.png)

The [Erosion Layer](#erosion-layer) is an extension layer for the [Fluid Simulation](#fluid-simulation) that simulates physically-based `hydraulic erosion, slope-based slippage, and terrain modification` based on the fluid's state and terrain slope.

The `Erosion Layer` is a texture-based system that analyzes the fluid simulation's state (fluid height and velocity) and the terrain's geometry to dynamically modify the ground. Modifications are applied directly to the associated terrain input (e.g., `SimpleTerrain` or `TerraformTerrain`) and fed back into the simulation to affect fluid flow.  

#### Multi-Layer Terrain System

 The erosion system allows you to define up to `four distinct terrain layers`, each with its own properties (e.g., hardness, color). The layers are structured from the bottom up:  
- **Layer Structure** The first element (Layer 0) represents the bottom-most layer (e.g., bedrock), and each subsequent element represents the material stacked on top. 
- **User Clarity** For clarity in the editor, you can give each layer a custom name (e.g., "Rock," "Soil," or "Snow") to help keep track of what it represents.   



#### Terrain Modification Processes

##### 1. Hydraulic Erosion (Water-Based)

 This process converts terrain material into **sediment** using two-dimensional textures, driven by the fluid's velocity field.  
-  **Erosion** Higher fluid velocity removes terrain material from the heightmap and transfers it into a Sediment Map.  
-  **Transport** The Sediment Map is continuously updated and advected (moved) across the grid according to the fluid's velocity field.  
-  **Deposition** Sediment is redeposited back onto the terrain heightmap in areas where the fluid flow is slower.    

##### 2. Slope-Based Slippage

 This process simulates gravity-driven effects (like landslides and thermal erosion). Material is removed and shifted to lower areas wherever the terrain's slope angle exceeds a configurable threshold (the material's angle of repose), helping to smooth steep cliffs over time.

| Property | Description |
| :--- | :--- |
| Terrain Layer | Identifies specific vertical layers within the terrain structure. |
| Terrain Layer Mask | A bitmask used to select multiple [Terrain Layer](#terrain-layer)s simultaneously. |
| Splat Channel | Identifies a specific color channel in a texture or splatmap. |
| Slippage | Toggles material slippage.<br/><br/>When enabled, material on steep slopes will naturally slide down to lower areas, smoothing the terrain over time. |
| Slippage Angle | The angle limit for slopes, in degrees.<br/><br/>Terrain slopes steeper than this angle will trigger slippage, causing material to slide down. |
| Slope Smoothness | Controls the intensity of the slippage effect.<br/><br/>Higher values result in more aggressive smoothing of slopes that exceed the [Slippage Angle](#slippage-angle). |
| Hydraulic Erosion | Toggles hydraulic erosion.<br/><br/>When enabled, moving fluid will wear down the terrain and transport sediment based on velocity and turbulence. |
| Max Sediment | The maximum amount of sediment a fluid cell can carry.<br/><br/>Once the sediment carried by the fluid reaches this limit, no further erosion will occur in that cell until material is deposited elsewhere. |
| Sediment Dissolve Rate | The rate at which solid terrain is picked up by the fluid.<br/><br/>Higher values cause the terrain to erode faster, provided the fluid has not reached its [Max Sediment](#max-sediment) capacity. |
| Sediment Deposit Rate | The rate at which carried sediment settles back onto the terrain.<br/><br/>Deposition occurs when the fluid slows down or when the carried material exceeds the capacity defined by [Max Sediment](#max-sediment). |
| Min Tilt Angle | Defines the minimum slope angle required for full hydraulic erosion efficiency.<br/><br/>This value modulates erosion based on the terrain's tilt.  <br/>-  **0 Degrees**  No restriction. Flat surfaces erode at the same rate as slopes.  <br/>-  **High Degrees**  Limits erosion primarily to steeper slopes, preserving flat areas. |
| Sediment Advection Speed | The speed at which sediment moves with the fluid flow.<br/><br/>Higher values transport material further across the world before it deposits. <br/><br/> Note: Because the erosion simulation is not strictly mass-conserving, very high speeds may cause sediment to "vanish" if it moves into cells with no fluid or off the edge of the simulation grid. |
| High Precision Advection | Toggles a higher-fidelity movement calculation for sediment.<br/><br/>When enabled, the simulation uses a more accurate method to move sediment. This prevents sediment from artificially fading away due to calculation errors but increases the GPU performance cost. |
| [Layer Settings](#erosion-settings) | A list of erosion configurations, allowing different physical properties to be applied to different terrain layers. |

<a name="erosion-settings"></a>
### Erosion Settings

Converts a [Terrain Layer Mask](#terrain-layer-mask) into a vector representation for shader operations.

| Property | Description |
| :--- | :--- |
| Name | The display name for this settings entry. |
| Slippage | Toggles material slippage.<br/><br/>When enabled, material on steep slopes will naturally slide down to lower areas, smoothing the terrain over time. |
| Slippage Angle | The angle limit for slopes, in degrees.<br/><br/>Terrain slopes steeper than this angle will trigger slippage, causing material to slide down. |
| Slope Smoothness | Controls the intensity of the slippage effect.<br/><br/>Higher values result in more aggressive smoothing of slopes that exceed the [Slippage Angle](#slippage-angle). |
| Hydraulic Erosion | Toggles hydraulic erosion.<br/><br/>When enabled, moving fluid will wear down the terrain and transport sediment based on velocity and turbulence. |
| Max Sediment | The maximum amount of sediment a fluid cell can carry.<br/><br/>Once the sediment carried by the fluid reaches this limit, no further erosion will occur in that cell until material is deposited elsewhere. |
| Sediment Dissolve Rate | The rate at which solid terrain is picked up by the fluid.<br/><br/>Higher values cause the terrain to erode faster, provided the fluid has not reached its [Max Sediment](#max-sediment) capacity. |
| Sediment Deposit Rate | The rate at which carried sediment settles back onto the terrain.<br/><br/>Deposition occurs when the fluid slows down or when the carried material exceeds the capacity defined by [Max Sediment](#max-sediment). |

<a name="terraform-layer"></a>
### Terraform Layer

![Terraform Layer](../../assets/images/terraformlayer.png)

The [Terraform Layer](#terraform-layer) is an advanced extension of the [Erosion Layer](#erosion-layer) that enables dynamic **terrain synthesis and multi-fluid interaction** (e.g., "God game" mechanics) by simulating complex layer transformations.

The `Terraform Layer` extends the base erosion system by adding highly customizable rules for material transformation between fluid and terrain layers. This facilitates complex real-time behaviors like fluid mixing, liquefaction, and contact-based reactions that modify both the terrain heightmap and splatmap.  

#### Liquefaction (Solid Terrain to Fluid)

 This feature allows a terrain layer (e.g., snow or ice) to dissolve into a selected fluid layer (e.g., water) over time. You can configure the `Liquify Rate` and the `Liquify Amount` (conversion ratio of terrain height to fluid depth) independently for each terrain layer.  

#### Fluid Contact Reactions (Fluid and Terrain)

 This system allows each terrain layer to react specifically when it comes into contact with any of the fluid layers. Reactions can be configured to:  
- **Dissolve** Consume the terrain and/or the fluid over time. 
- **Convert** Change the terrain into a new terrain layer (with a new splat channel) or convert the terrain into a different fluid layer (e.g., snow reacting to `Lava` to create `Water`). 
- **Volume Control** Adjust the `Terrain Volume` and `Fluid Volume` multipliers to simulate material expansion or compression during the transformation.   

#### Fluid Mixing (Fluid + Fluid to Solid Terrain)

 When two different fluid layers occupy the same cell, this system can be triggered to simulate a reaction (e.g., water and lava mixing to cool and solidify into rock).  
- **Solidification** The mixing fluids are consumed and deposited as a new, solid terrain layer onto the heightmap and splatmap. 
- **Particle Emission** The system can emit visual particles (e.g., steam) upon mixing, with customizable settings for `Emission Rate`, color, and lifetime.   

 `Setup Note:` While this component must be attached to a GameObject, it also requires registration in the [Extension Layers](#extension-layers) list to function correctly.

| Property | Description |
| :--- | :--- |
| Fluid Mixing | Toggles the interaction logic between overlapping fluid types.<br/><br/>When enabled, if two distinct fluids (e.g., Water and Lava) occupy the same grid cell, they will trigger a mixing event. In standard configurations, this results in the fluid volume being consumed and converted into solid terrain geometry. |
| Fluid Mix Rate | Controls the speed of the reaction between interacting fluids.<br/><br/>Higher values cause the fluids to consume each other and generate terrain more rapidly. |
| Fluid Mix Scale | The volumetric conversion ratio between consumed fluid and generated terrain.<br/><br/>This value determines how much solid ground is created for every unit of fluid lost during mixing.  <br/>-  **1.0**  One unit of fluid volume converts exactly to one unit of terrain volume.  <br/>-  **Greater than 1.0**  The reaction expands, creating more terrain than the fluid consumed.  <br/>-  **Less than 1.0**  The reaction contracts, creating less terrain than the fluid consumed. |
| Deposit Rate | The rate at which the newly solidified material is integrated into the terrain's heightmap.<br/><br/>While [Fluid Mix Rate](#fluid-mix-rate) controls the fluid consumption, this controls the visual rise of the ground. Lower values can smooth out the generation process, preventing abrupt spikes in the terrain mesh. |
| Deposit Terrain Layers | Specifies which vertical terrain layer (e.g., Bedrock or Sediment) receives the newly generated geometry. |
| Deposit Terrain Splat | Specifies the material channel (R, G, B, or A) in the splatmap to apply to the newly generated terrain.<br/><br/>This ensures that the new ground visually matches the expected material (e.g., setting the channel to display "Obsidian" or "Rock" texture where lava hardened). |
| [Fluid Particles](#fluid-particle-system) | Configuration for the particle system emitted during fluid mixing events.<br/><br/>This is commonly used to create steam or smoke effects when hot fluids interact with cool fluids (e.g., Lava meeting Water). |
| Emission Rate | The time interval, in seconds, between consecutive particle spawn events at a mixing location.<br/><br/>A lower value results in a higher frequency of particle emission (more particles), while a higher value results in sparse emission. |

<a name="fluid-contact-reaction"></a>
#### Fluid Contact Reaction

Defines the changes that occur when a specific terrain layer comes into contact with fluid.

This class acts as a "recipe" for interactions, such as Lava turning Grass into Rock (scorching) or Water turning Soil into Mud.

| Property | Description |
| :--- | :--- |
| Enabled | Toggles this specific contact reaction. |
| Conversion Rate | The global speed multiplier for this reaction.<br/><br/>Defines how fast the transition happens in units per second. Higher values result in near-instant transformations. |
| Terrain Dissolve Amount | The amount of solid terrain removed per second while in contact with the fluid.<br/><br/>Use this to simulate the terrain being "eaten away" or dissolved by the fluid. |
| Fluid Consumption Amount | The amount of fluid volume consumed per second during the reaction.<br/><br/>Use this to simulate fluid evaporating (e.g., lava cooling on rock) or soaking into the ground. |
| Convert To Terrain Layer | The target terrain layer that the original terrain will transform into.<br/><br/>For example, if Water touches a "Dirt" layer, you might set this to a "Mud" layer. |
| Convert To Splat Channel | The visual texture (splat channel) applied to the transformed terrain.<br/><br/>This updates the terrain's appearance to match its new physical properties (e.g., turning green grass texture into grey rock). |
| Convert To Terrain Volume | The volumetric conversion ratio for generating new terrain.<br/><br/>Determines how much new solid ground is created relative to the amount consumed.  <br/>-  **1.0**  One unit of consumed terrain becomes exactly one unit of new terrain.  <br/>-  **Greater than 1.0**  The reaction expands, creating more terrain volume than was consumed. |
| Convert To Fluid Layer | The target fluid layer to generate when the terrain dissolves.<br/><br/>Use this for reactions where solid ground turns into liquid, such as Lava melting Ice into Water. |
| Convert To Fluid Volume | The volumetric conversion ratio for generating new fluid.<br/><br/>Determines how much liquid is produced relative to the amount of terrain dissolved.  <br/>-  **1.0**  One unit of terrain height becomes one unit of fluid depth.  <br/>-  **Greater than 1.0**  The reaction expands, creating more fluid volume than the terrain that was dissolved. |

<a name="terraform-settings"></a>
#### Terraform Settings

An extended configuration profile for the [Terraform Layer](#terraform-layer), including standard erosion settings and advanced contact interactions.

| Property | Description |
| :--- | :--- |
| Liquify | Toggles the automatic "liquefaction" of this terrain layer over time, independent of fluid contact.<br/><br/>Useful for simulating unstable materials like melting snow or ice that naturally turns into fluid. |
| Liquify Layer | The target fluid layer (e.g., Layer 1, Layer 2) that this terrain layer dissolves into when [Liquify](#liquify) is enabled. |
| Liquify Rate | The speed at which the terrain naturally dissolves into fluid, in units of height per second. |
| Liquify Amount | The volumetric conversion ratio of terrain height to fluid depth during liquefaction.<br/><br/>-  **1.0**  1 unit of terrain height becomes 1 unit of fluid depth.  <br/>-  **2.0**  1 unit of terrain produces 2 units of fluid. |
| [Fluid Layer1Contact](#fluid-contact-reaction) | Defines the reaction rules applied when this terrain layer comes into contact with Fluid Layer 1. |
| [Fluid Layer2Contact](#fluid-contact-reaction) | Defines the reaction rules applied when this terrain layer comes into contact with Fluid Layer 2. |

<a name="terrain-modifier"></a>
### Terrain Modifier
[Terrain Modifier](#terrain-modifier) is a component used to interactively modify the underlying terrain heightfield within the [Fluid Simulation](#fluid-simulation).

This component acts as a "brush" for precise terrain editing, allowing you to raise, lower, or set the height of the solid ground layer. It is ideal for dynamic world sculpting or in-game level editing.  

 **Note:** This component requires and works in conjunction with a specialized terrain system on the [Fluid Simulation](#fluid-simulation), such as the `TerraformLayer` or `ErosionLayer` and the `Simple/TerraformTerrain` types, to enable terrain height modifications.  

 The modification effect is defined by the [Terrain Modifier Settings](#terrain-modifier-settings) and applied within a localized area determined by the selected [Terrain Input Mode](#terrain-input-mode) and [Size](#size).

![alt text](../../assets/images/terrainmodifier.png)

<a name="terrain-modifier-settings"></a>
#### Terrain Modifier Settings

| Property | Description |
| :--- | :--- |
| Mode | Defines the shape or source of the modification brush.<br/><br/>Input modes include:  <br/>-  **[Circle](#circle)**  The brush applies the modification within a circular area.  <br/>-  **[Box](#box)**  The brush applies the modification within a rectangular area.  <br/>-  **[Texture](#texture)**  The brush uses a source texture to define the shape and intensity. |
| Blend Mode | Defines the mathematical operation used to apply the modification to the terrain.<br/><br/>This determines how the modification is applied to the terrain. Options include:  <br/>-  **[Additive](#additive)**  Raising or lowering the height over time.  <br/>-  **[Set](#set)**  Setting the height to a specific value.  <br/>-  **[Minimum](#minimum)/[Maximum](#maximum)**  Clamping the height to the target value. |
| Space | Specifies the coordinate space used for height modifications.<br/><br/>-  **[World Height](#world-height)**  The height is interpreted as a specific world Y-coordinate.  <br/>-  **[Local Height](#local-height)**  The height is interpreted relative to the base terrain height. |
| Strength | Controls the magnitude or intensity of the terrain deformation.<br/><br/>- For Additive blending, this is the amount of height to add/subtract *per second*.<br/> - For Set, Minimum, or Maximum blending, this value contributes to the target height. |
| Remap | Adjust the range used to remap the normalized input value (e.g., from a texture) to the final output strength.<br/><br/>A normalized input of 0 is mapped to `remap.x`, and an input of 1 is mapped to `remap.y`. |
| Falloff | Adjust the softness of the brush edge (falloff) for the Circle and Box input modes.<br/><br/>Higher values create a wider and softer transition at the modification boundary. |
| Size | Adjust the size (width and height) of the modification area in world units. |
| Layer | Specifies the target terrain layer (e.g., a specific heightmap channel) to modify.<br/><br/>Typically used to select between the channels of a multi-channel heightmap, such as channel 0 for Red and 1 for Green. |
| Splat | Specifies the target splatmap channel to use when the blend mode involves a terrain splatmap.<br/><br/>Used to select a specific texture layer for blending (e.g., channel 0 for Red, 1 for Green, etc.). |
| Texture | The source texture used to define the modification shape and intensity when [Mode](#mode) is set to [Texture](#texture). |

<a name="terraform-modifier"></a>
### Terraform Modifier

[Terraform Modifier](#terraform-modifier) is a component used to interactively modify both the terrain and fluid layers within the [Fluid Simulation](#fluid-simulation).

![Terraform Modifier](../../assets/images/terraform_modifier.png)

This component acts as a "brush" to simulate the transformation of material layers between solid ground and liquid fluid. It enables real-time interactive effects, such as melting snow/ice (`liquify`) into water or the water into snow (`solidify`), making it ideal for "God games" or complex world interaction scenarios.

**Note:** This component requires and works in conjunction with the `TerraformLayer` (or a similar erosion/terrain modification system) on the [Fluid Simulation](#fluid-simulation) to enable the material transformation process.

The modification effect is defined by the [Terraform Modifier Settings](#terraform-modifier-settings) and applied within a localized area determined by the selected **Terraform Input Mode** and size.

<a name="terraform-modifier-settings"></a>
##### Terraform Modifier Settings

| Property | Description |
| :--- | :--- |
| Mode | Set the shape of the modification brush (Circle, Box, Sphere, Cube, Cylinder, Capsule). |
| Size | Adjust the dimensions of the modification area in world units. Interpretation varies by mode (e.g., Circle uses X for radius, Box uses X/Z for width/depth). |
| Falloff | Adjust the sharpness of the brush edge. Higher values create a softer edge. |
| Liquify | If enabled, the modifier will attempt to dissolve terrain into fluid (liquify). |
| Source Terrain Layer | Set the terrain layer (e.g. Layer 1, Layer 2) that will be dissolved. |
| Target Fluid Layer | Set the fluid layer (e.g., Layer 1, Layer 2) that this terrain will dissolve into. |
| Liquify Rate | Set the speed at which the terrain dissolves into fluid, in units of height per second. Higher values mean faster melting or dissolving.. |
| Liquify Amount | Set the conversion ratio of terrain height to fluid depth. A value of 1 means 1 unit of terrain<br/>height becomes 1 unit of fluid depth. A value of 2 means 1 unit of terrain becomes 2 units of fluid. |
| Solidify | If enabled, the modifier will attempt to solidify fluid into terrain. |
| Target Terrain Layer | Set the terrain layer (e.g. Layer 1, Layer 2) that will be built up. |
| Target Splat Channel | Set the splat channel (e.g., R, G, B, A) that will be used to paint the built-up terrain. |
| Source Fluid Layer | Set the fluid layer (e.g., Layer 1, Layer 2) that will be consumed to create terrain. |
| Solidify Rate | Set the speed at which the fluid solidifies into terrain, in units of height per second. Higher values mean faster build-up of terrain. |
| Fluid to Terrain Ratio | Set the conversion ratio of fluid depth to terrain height. A value of 1 means 1 unit of fluid<br/>depth becomes 1 unit of terrain height. A value of 2 means 2 units of fluid become 1 unit of terrain. |


<a name="particle-generator"></a>
### Fluid Particle Generator
<sub>**This functionality is subject to future changes.**</sub>

[Fluid Particle Generator](#fluid-particle-generator) is an [Fluid Layer](#fluid-layer) extension that analyzes the fluid simulation's dynamics to spawn and manage visual particle effects for foam and spray.

This component generates two distinct types of particles by detecting areas of high turbulence and breaking waves within the fluid simulation:   
-  **Splash Particles (Spray/Droplets)**  Ballistic particles spawned at high-energy events (e.g., breaking waves, collisions). These particles inherit the fluid's velocity at the moment of spawn and follow a physical trajectory (like spray or droplets) until their lifetime expires.  
-  **Surface Particles (Foam/Bubbles)**  Particles spawned on top of the fluid surface, primarily in areas of high turbulence. They are continuously advected (moved) by the simulation's velocity field, acting as a visual representation of sea foam or churn. These particles can often be rendered to an off-screen buffer for use as a `foam mask` in the water shader.

#### Splash Particles

![Splash Particles](../../assets/images/fluidparticlegenerator_splash.png)


| Property | Description |
| :--- | :--- |
| Breaking Wave Splashes | Toggles the emission of splash particles from cresting or breaking waves. |
| Steepness Threshold | The minimum surface angle (steepness) required to trigger a splash.<br/><br/>Higher values restrict splashes to only the sharpest peaks of the waves. |
| Rise Rate Threshold | The minimum vertical (upward) velocity required to trigger a splash.<br/><br/>Used to identify waves that are rising rapidly before they break. |
| Wave Length Threshold | The minimum physical length a wave must have to emit particles.<br/><br/>Helps prevent small, high-frequency noise from generating excessive spray. |
| Breaking Wave Grid Stagger | Optimization setting that spreads the sampling of grid cells for breaking waves across multiple frames.<br/><br/>A value of 2 means a specific cell is checked every 2nd frame. Increasing this value reduces the number of particles spawned and lowers performance cost, but may make emission look less responsive. |
| Turbulence Splashes | Toggles the emission of spray particles from areas of high turbulence (diverging velocities). |
| Turbulence Splash Grid Stagger | Optimization setting that spreads the sampling of grid cells for turbulence splashes across multiple frames. |
| Spray Turbelence Threshold | The minimum turbulence value required to trigger a splash particle. |
| [Splash Particle System](#fluid-particle-system) | Configuration settings for the ballistic splash particles (movement, rendering, and limits). |

##### Particle System
| Property | Description |
| :--- | :--- |
| Update Mode | Defines the execution strategy for the particle update loop. |
| Max Particles | The maximum number of particles that can be active simultaneously in the simulation buffer.<br/><br/>This value determines the size of the GPU [Graphics Buffer](#graphics-buffer) allocated for the system. Increasing this allows for denser effects but increases VRAM usage and GPU processing cost. |
| Material | The material used to render the particle geometry.<br/><br/>Requirement: The assigned material must use a shader capable of procedural instantiation, such as the included `ProceduralParticle` or `ProceduralParticleUnlit` shaders. |
| Layer | The Unity Layer index assigned to the rendered particles.<br/><br/>This is used to control visibility via Camera Culling Masks, allowing specific cameras (e.g., UI or reflection probes) to ignore these particles. |

#### Surface Particles

![Surface Particles](../../assets/images/fluidparticlegenerator_surface.png)

| Property | Description |
| :--- | :--- |
| Turbulence Surface | Toggles the emission of surface particles (foam) in turbulent areas.<br/><br/>Unlike splashes, these particles stick to the fluid surface and move with the flow. |
| Surface Turblence Threshold | The minimum turbulence value required to trigger a surface particle. |
| Surface Grid Stagger | Optimization setting that spreads the sampling of grid cells for surface particles across multiple frames. |
| [Surface Particles System](#fluid-particle-system) | Configuration settings for the advected surface particles (movement, rendering, and limits). |
| Render Offscreen | If enabled, surface particles are rendered to a dedicated offscreen texture buffer instead of the main camera.<br/><br/>This generated texture is globally available to shaders (e.g., as a foam mask) to create effects like white water trails without drawing individual particle geometry to the screen. |

##### Particle System
| Property | Description |
| :--- | :--- |
| Update Mode | Defines the execution strategy for the particle update loop. |
| Max Particles | The maximum number of particles that can be active simultaneously in the simulation buffer.<br/><br/>This value determines the size of the GPU [Graphics Buffer](#graphics-buffer) allocated for the system. Increasing this allows for denser effects but increases VRAM usage and GPU processing cost. |
| Material | The material used to render the particle geometry.<br/><br/>Requirement: The assigned material must use a shader capable of procedural instantiation, such as the included `ProceduralParticle` or `ProceduralParticleUnlit` shaders. |
| Layer | The Unity Layer index assigned to the rendered particles.<br/><br/>This is used to control visibility via Camera Culling Masks, allowing specific cameras (e.g., UI or reflection probes) to ignore these particles. |

<a name="fluid-rigidbody"></a>
### Fluid RigidBody

Enables high-fidelity, two-way physics coupling between a [Rigidbody](#rigidbody) and a [Fluid Simulation](#fluid-simulation)'s heightfield grid, allowing the body to be affected by the fluid and to generate displacement, wakes, and splashes.

The component performs geometry-to-fluid interaction using an optimized system that leverages **Unity Jobs** for multithreaded performance.  

![Fluid Rigid Body](../../assets/images/fluidrigidbody.png)

#### Prerequisite
 
 To allow the CPU to access the fluid height for buoyancy calculations, the [Read Back Height](#read-back-height) (`CPU Height Read`) setting must be enabled on the [Fluid Simulation](#fluid-simulation).  

#### Fluid Density Calibration

 To ensure objects float correctly, the global fluid density setting, accessed via [Fluid Density](#fluid-density), must be calibrated to match your project's physics scale (where mass and size often do not follow real-world proportions).  

 If Rigidbodies (e.g., a vehicle with a mass of 1500) sink when they should float, the fluid density is likely too low for that mass magnitude. A good starting point is to set the [Fluid Density](#fluid-density) value to be similar to the mass of an average-sized object you expect to float.  

#### Interaction Calculation

  
-  **Fluid to Solids Coupling (Forces)**   The component calculates and applies realistic forces to the object's [Rigidbody](#rigidbody). Forces are determined by analyzing the volume and state of the body's submerged **sub-triangulated geometry** against the fluid's state. These include:  `Buoyancy`: Calculated from the weight of the displaced fluid, based on the submerged volume. `Drag and Lift`: Applied based on the relative velocity of the body to the fluid.    
-  **Solids to Fluid Coupling (Displacement)**   The object's movement displaces the fluid, generating wakes and splashes. This is calculated by applying the volume and velocity changes of the submerged sub-triangles to the fluid's closest `height field` and `velocity grid cells`. The effect is decayed exponentially with increasing distance from the surface.   
-  **Requirements and Limitations**   The component requires a [Rigidbody](#rigidbody) and a supported [Collider](#collider), such as [Mesh Collider](#mesh-collider), [Sphere Collider](#sphere-collider), [Box Collider](#box-collider), or [Capsule Collider](#capsule-collider), on the same GameObject. This component is `not compatible with WebGL` due to its reliance on compute shaders.

| Property | Description |
| :--- | :--- |
| Apply Fluid Displacement | A toggle for the solid-to-fluid interaction. If true, this object will displace the fluid, creating splashes and wakes. |
| [Displacement Profile](#fluid-displacement-profile) | A profile containing the detailed physics parameters that control how this object displaces the fluid (e.g., wave height, current strength). |
| Subdivision Area Threshold | The area threshold used to recursively subdivide a MeshCollider's triangles for the solid-to-fluid displacement pass.<br/><br/>Each triangle of the source mesh is checked against this value. If its area is larger, it is recursively split into four smaller sub-triangles until all resulting triangles are below this area. This creates a higher-density representation of the mesh, leading to more accurate and detailed fluid displacement (splashes and wakes). Lowering this value increases visual quality at the cost of higher memory usage (for the GraphicsBuffer) and GPU processing time. |
| Apply Fluid Forces To Rigibody | A toggle for the fluid-to-solid interaction. If true, the fluid will apply forces like buoyancy, drag, and lift to this object's Rigidbody. |
| Center Of Mass Offset | The custom center of mass for the Rigidbody ofset, calculated in local space.<br/><br/>By default, a Rigidbody's center of mass is at its geometric center, which is often too high for a boat, making it "top-heavy" and prone to capsizing in turns or rough water. By setting a negative Y value, you can artificially lower the center of mass, making the object "bottom-heavy." This creates a strong restoring torque that resists rolling and keeps the object upright, similar to the keel on a real boat. |
| [Interaction Profile](#fluid-interaction-profile) | A profile containing the detailed physics parameters that control how the fluid affects this object (e.g., drag and lift coefficients). |
| Sampling Group Size | The size of the grid cells used to group the object's surface points for optimization.<br/><br/>A performance tuning parameter that groups the object's surface points into a grid for optimized fluid sampling. Smaller values increase accuracy at a potential performance cost. A good starting value roughly matches the cell size of the fluid simulation. |
| Sphere Sample Count | The total number of sample points to generate on the surface of a SphereCollider for the fluid-to-solid (buoyancy) calculations. |
| Box Face Sample Count | The number of sample points to generate along each axis of a BoxCollider's face. For example, a value of 8 will create an 8x8 grid of points on each of the 6 faces. |
| Capsule Sample Count | The total number of sample points to generate on the surface of a CapsuleCollider, distributed proportionally across its cylindrical body and hemispherical caps. |

<a name="fluid-displacement-profile"></a>
#### Fluid Displacement Profile

A container for the physics coefficients that define how a solid object displaces and applies forces TO the fluid simulation. This controls the "splash" and "wake" created by the object.

| Property | Description |
| :--- | :--- |
| Height Influence | Controls how strongly the object's volume displaces the water's height. This is the primary factor in determining the size of waves generated by the object.<br/><br/>A higher value will cause the object to create larger waves and splashes upon impact, making it feel like it's displacing more water. A value of 0 would mean the object slices through the water without changing its height at all. |
| Velocity Influence | Controls how much of the object's velocity is transferred to the water, creating currents and wakes.<br/><br/>A higher value will cause the object to "drag" the water along with it more effectively, creating stronger currents in its wake. A value of 0 would mean the object moves through the water without affecting its velocity. |
| Velocity Scale | A multiplier that scales the velocity deltas. This acts as a global artistic control for the object's overall displacement.<br/><br/>This is a non-physical parameter useful for tuning the visual impact. You can use it to exaggerate or dampen an object's effect without altering the more physically-based ratio between its height and velocity displacement. |

<a name="fluid-interaction-profile"></a>
#### Fluid Interaction Profile

A container for the physics coefficients that define how a Rigidbody is affected by fluid forces (drag, lift).

| Property | Description |
| :--- | :--- |
| Drag Coefficient | The drag coefficient (CD), representing how much the fluid resists the object's motion through it. This is a dimensionless number that models the "thickness" or resistance of the fluid.<br/><br/>A higher value increases resistance, making the object feel like it's moving through a thicker substance (e.g., mud or honey). A lower value reduces resistance, making the object feel lighter and more slippery. |
| Lift Coefficient | The lift coefficient (CL), representing the force generated perpendicular to the direction of fluid flow. This models how a surface's shape can act like a wing or a spoiler in the water.<br/><br/>This can create an upward force (like on a hydrofoil) or a downward force (like a spoiler on a race car) depending on the surface's angle relative to the flow. It's crucial for simulating dynamic, unstable behavior. |
| Effective Area Weight | The weighting factor that blends between using the full surface area and the projected area that directly faces the fluid flow.<br/><br/>A value of 0 means the object's orientation to the flow doesn't matter; it experiences the same drag from all sides. A value of 1 means only the surface area directly facing the flow contributes, making the object highly sensitive to its angle. A value of 0.5 provides a balanced mix. |

<a name="fluid-rigidbody-lite"></a>
### Fluid RigidBody Lite

[Fluid Rigid Body Lite](#fluid-rigid-body-lite) is a lightweight component for simplified interaction between a [Rigidbody](#rigidbody) and the [Fluid Simulation](#fluid-simulation).

This component applies physics effects such as buoyancy, drag, and advection (movement by the current), and allows the object to generate visual wave and splash effects on the fluid surface. It is designed for performance with minimal setup.  

 **Requirement:** This component requires both a [Rigidbody](#rigidbody) and a [Collider](#collider) to be attached to the [Game Object](#game-object).  

 **Prerequisite:** To allow the CPU to access the fluid height for buoyancy calculations, the [Read Back Height](#read-back-height) (`CPU Height Read`) setting must be enabled on the [Fluid Simulation](#fluid-simulation).

![Fluid Rigidbody Lite](../../assets/images/fluidrigidbody_lite.png)

##### Waves

| Property | Description |
| :--- | :--- |
| Create Waves | If enabled, the object will interact with the fluid simulation by creating waves in its direction of movement (e.g., wakes). |
| Wave Radius | Adjusts the radius (size) of the generated wave/wake on the fluid surface. |
| Wave Strength | Adjusts the height (amplitude) or intensity of the wave. |
| Wave Exponent | Adjusts the falloff curve of the wave's strength. Higher values mean a faster falloff, which can be used to create sharper or flatter wave/vortex shapes. |

##### Splashes

| Property | Description |
| :--- | :--- |
| Create Splashes | If enabled, the object will interact with the fluid simulation by generating splashes when falling into the fluid. |
| Splash Force | Adjusts the force applied to the fluid simulation when the object lands in the fluid. Faster falling objects create bigger splashes. |
| Splash Radius | Adjusts the size of the splash area on the fluid surface. |
| Splash Time | Adjusts the time duration over which the splash force is applied while surface contact is made. |
| [Splash Particles](#splash-particle-system) | A list of [Splash Particle System](#splash-particle-system) settings that will be spawned when the rigid body makes contact with the fluid. |

##### Physics

| Property | Description |
| :--- | :--- |
| Advection Speed | Adjusts the influence the [Fluid Simulation](#fluid-simulation) velocity field (current) has on the object. Higher values will move the object through the fluid at faster speeds. |
| Drag | Adjusts the amount of linear drag applied to the object when it is in contact with the fluid. |
| Angular Drag | Adjusts the amount of angular (rotational) drag applied to the object when it is in contact with the fluid. |
| Buoyancy | Adjusts the buoyancy of the object. Higher values increase the upward force, causing the object to float higher. Lower values make the object float lower or sink. |

<a name="splash-particle-system"></a>
##### Splash Particle System

| Property | Description |
| :--- | :--- |
| System | The [Particle System](#particle-system) to be emitted when the rigidbody hits the fluid. |
| Override Splash Particles | If enabled, the particle system's start velocity and emission rate will be overwritten based on the rigidbody's impact speed with the fluid. |
| Splash Emission Rate | The static or overridden number of particles to emit when the rigidbody hits the fluid. |
| Splash Particle Speed Scale | Adjusts the starting speed multiplier of the emitted particles. |


<a name="fluid-simulation-obstacle"></a>
### Fluid Simulation Obstacle
[Fluid Simulation Obstacle](#fluid-simulation-obstacle) is a component that can be added to any object with a [Renderer](#renderer) component attached, or configured to use a procedural shape.

When this component is attached, its shape and height are `orthographically rendered` onto the fluid simulation's underlying ground heightfield. This tells the [Fluid Simulation](#fluid-simulation) where the obstacle is, allowing the fluid to correctly flow around or over it. The obstacle itself can be `moved dynamically` during runtime.  

 `Important Note on Movement:` The simulation's heightfield model means the fluid cannot flow under the obstacle. If the obstacle moves quickly into a location where water is currently present, that water will be instantly forced on top of the obstacle. `Rapidly moving a large obstacle can cause extreme visual artifacts` (like large, unnatural splashes or wild fluid behavior) due to the sudden volume displacement. It is generally advised to use this component on objects that are mostly rounded (e.g., rocks or islands) or those that do not create highly concave shapes with the surrounding terrain.

![alt text](../../assets/images/fluidsimulationobstacle.png)

#### Settings

| Property | Description |
| :--- | :--- |
| Obstacle Mode | Defines the source used to determine the obstacle's height and shape within the fluid simulation grid. |
| Obstacle Shape | Defines the type of procedural shape to use when [Mode](#mode) is set to [Shape](#shape). |
| Mode | The method used to define the obstacle's shape for the heightmap render. Defaults to [Renderer](#renderer). |
| Shape | The type of procedural primitive to use when [Mode](#mode) is [Shape](#shape).<br/><br/>- Sphere<br/> <br/>- Box<br/> <br/>- Cylinder<br/> <br/>- Capsule<br/> <br/>- Ellipsoid<br/> <br/>- CappedCone<br/> <br/>- HexPrism<br/> <br/>- Wedge |
| Center | Local offset from the Transform position. |
| Size | The XYZ dimensions for non-uniform procedural shapes.<br/><br/>- **Box:** The full width, height, and depth.<br/> <br/>- **Ellipsoid:** The diameter of the X, Y, and Z axes.<br/> <br/>- **Wedge:** The bounding dimensions of the wedge base and height. |
| Radius | The primary radius for rounded procedural shapes.<br/><br/> <br/>- **Sphere:** The radius of the sphere.<br/> <br/>- **Cylinder:** The radius of the base.<br/> <br/>- **HexPrism:** The radius of the base.<br/> <br/>- **Capsule:** The radius of the cylinder body and the hemispherical end-caps.<br/> <br/>- **Capped Cone:** The radius of the bottom base. |
| Secondary Radius | An secondary radius used for complex shapes. <br/> <br/>- **Capped Cone:** The radius of the top cap. |
| Height | The total length or height of the procedural shape along its alignment [Direction](#direction). |
| Direction | The local axis that the procedural shape's height or length is aligned with.<br/><br/>- **0:** X-Axis (Horizontal)<br/> <br/>- **1:** Y-Axis (Vertical)<br/> <br/>- **2:** Z-Axis (Forward) |
| Conservative Rasterization | Ensures that even sub-pixel geometry is captured during the heightfield bake.<br/><br/>Standard rasterization only renders a pixel if its center is covered by a triangle. <br/>Conservative Rasterization renders a pixel if any part of it is touched by a triangle.<br/><br/>Enabling this prevents thin obstacles like thin walls from being missed <br/>if they happen to fall between pixel centers, ensuring more reliable collision data.<br/>This may cause the obstacle to appear slightly larger than its actual mesh.<br/><br/>***Warning***: This feature requires hardware-level support. It is not supported on platforms like WebGL, OpenGL ES, <br/>or older mobile devices. The system will automatically fall back to standard <br/>rasterization on unsupported hardware. |
| Smooth Rasterization | Enables multi-sampling to produce smoother edges for procedural shapes.<br/><br/>When disabled, procedural shapes are sampled at a single point per grid cell, which can result in jagged edges or<br/>stair stepping in the heightfield. When enabled, the shader performs a multi-sample average <br/>to create a soft, anti-aliased edge.<br/><br/>***Warning***: Because this averages height values within a local neighborhood, perfectly vertical drops <br/>(like the sides of a box) might be turned into slopes. This can lead to height leakage or cause fluid <br/>to climb the edges of an obstacle instead of colliding with a sharp wall. |

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
