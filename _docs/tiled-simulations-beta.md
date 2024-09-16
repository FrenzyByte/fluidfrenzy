---
title: Tiled Simulations (Beta)
permalink: /docs/tiled_simulations_beta/
---


Tiled Simulations have been made available in Fluid Frenzy in version v1.0.6 as a beta feature if there any bugs, issues or suggestions please report them [here](https://github.com/FrenzyByte/fluidfrenzy/issues). 
To enable this feature add the following symbol to your **Scripting Define Symbols** in the project settings: `FLUIDFRENZY_NEIGHBOURS_ENABLED`

![Tiled Simulation Gizmos](../../assets/images/tiled_simulation_playersettings.png)

When requiring multiple terrains to make up a bigger world, Fluid Frenzy can add a simulation to each of these terrains and connect the simulations together. This feature allows neighbouring simulations to interact with each other, Fluid can flow between simulations freely.

Neighbouring simulations can be added using the scene view gizmos similar to how the Unity Terrain system adds terrain tiles. Pressing the gizmo adds a new [Fluid Simulation](../fluid_simulation_components#fluid-simulation) and attempts to automatically copy all settings assigned to the original fluid Simulation to the new simulation and connect up any terrain (if available). 

![Tiled Simulation Gizmos](../../assets/images/tiled_simulation.png)

Alternatively neighbours can be setup manually by dragging a [Fluid Simulation](../fluid_simulation_components#fluid-simulation) in the corresponding *Neighbour* field [Fluid Simulation](../fluid_simulation_components#fluid-simulation)  in the inspector.

![Tiled Simulation Inspector](../../assets/images/tiled_simulation_neighbours.png)

When neighbouring tiles use features like flow/foam mapping they require extra padding to simulate the same as their neighbour for optimal performance. The setting for padding can be found on the [Fluid Simulation Settings](../fluid_simulation_components#fluid-simulation-settings). 

![alt text](../../assets/images/tiled_simulation_padding.png)

The amount of padding required depends on the resolution of the texture and defaults to 0%. The padding can be increased by multiple of two increments.



---

<div style="page-break-after: always;"></div>

<a name="future-updates-roadmap"></a>
