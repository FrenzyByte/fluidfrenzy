---
title: Physics Colliders
permalink: /docs/physics_colliders/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

<a name="surface-collider"></a>
### Surface Collider

Manages the generation and synchronization of a Unity physics collider to allow physical interactions, such as collisions and raycasting, with the dynamic fluid surface and underlying terrain.

This optional feature enables physical interaction between standard Unity physics components and the elements simulated by Fluid Frenzy, specifically the `FluidSimulation` and the underlying `SimpleTerrain/TerraformTerrain`.  

![physics collider](../../assets/images/physics-collider.png)

#### GPU-CPU Synchronization and Performance

  Since the fluid is simulated entirely on the GPU, the height data required for a physics collider must be transferred back to the CPU to generate the surface. This **GPU-readback** and the subsequent collider generation are inherently expensive operations.  

 To prevent the application from experiencing large stalls, the update process is managed by the `SurfaceCollider` class. It operates **asynchronously** and uses **timeslicing** to spread the computational load across multiple frames. The system provides a critical trade-off:   
- Increasing the number of timesliced frames reduces the per-frame cost. 
- However, this also increases the update delay, meaning the physics surface lags further behind the current fluid state.  

 The system includes several settings to modify both the quality of the generated collider and the performance characteristics of this synchronization process.

<a name="collider-properties"></a>
#### Collider Properties

Encapsulates settings used for configuring and initializing [Surface Collider](#surface-collider).

| Property | Description |
| :--- | :--- |
| Create Collider | Toggles the generation of a [Terrain Collider](https://docs.unity3d.com/ScriptReference/TerrainCollider.html) to handle physical interactions with the fluid surface. |
| Resolution | Specifies the grid resolution of the generated [Terrain Collider](https://docs.unity3d.com/ScriptReference/TerrainCollider.html).<br/><br/>This value determines the density of the physics mesh. Higher resolutions result in more accurate physical interactions but increase generation time and physics processing overhead. <br/><br/> Internally, the actual grid size is set to `resolution + 1` to satisfy heightmap requirements. |
| Realtime | Controls whether the collider's heightmap is updated at runtime to match the visual fluid simulation.<br/><br/>When enabled, the simulation data is continuously synchronized with the physics collider. Note that this process requires reading GPU terrain data back to the CPU and applying it to the **Terrain Data**, which can be resource-intensive and cause garbage collection spikes. |
| Update Frequency | The interval, in frames, between consecutive collider updates when [Realtime](#realtime) is enabled.<br/><br/>Increasing this value reduces the performance cost of the readback but causes the physics representation to lag behind the visual rendering. |
| Timeslicing | The number of frames over which a single full collider update is distributed.<br/><br/>This feature splits the heightmap update into smaller segments, processing only a fraction of the data per frame. This helps to smooth out performance spikes and maintain a stable framerate, though it increases the time required for the collider to fully reflect a change in the fluid surface. |
---

<div style="page-break-after: always;"></div>

<a name="simulation-debug-editor"></a>
