---
title: Physics Colliders
permalink: /docs/physics_colliders/
---


Fluid Frenzy has optional support for Unity's physics colliders and raycasting by generating a collider for the **SimpleTerrain/TerraformTerrain** and **FluidSimulation**. 
Since Fluid Frenzy simulates entirely on the GPU the data needs to be read back to the CPU to generate a collider. Both the GPU-readback and generation are expensive operations.
To prevent large stalls the update is performed asynchronously and uses timeslicing over multiple frames. The more timesliced frames the higher the update delay, but the lower the per frame cost.

There are several settings to modify the quality and performance of the collider:

![physics collider](../../assets/images/physics-collider.png)

- **Create Collider** - toggles the generation of a TerrainCollider to use for physics.
- **Resolution** - the quality of the TerrainCollider grid. Higher resolutions means more accurate physics, at the cost of longer generation times. Internally the grids resolution is resolution+1.
- **Update Realtime** - update the collider in real time every Nth frame to match the collider with the rendered data. Updating the collider requires the GPU terrain data to be read back to the CPU and applied to the TerrainData this can be expensive.
- **Frequency** - update the collider in real time every Nth frame to match the collider with the rendered data. Updating the collider requires the GPU terrain data to be read back to the CPU and applied to the TerrainData, which can be resource-intensive.
- **Timeslice** - splits the update of the heightmap in several segments. Each segment will be rendered on a different frame. A full collider update takes this many frames.

---

<div style="page-break-after: always;"></div>

<a name="simulation-debug-editor"></a>
