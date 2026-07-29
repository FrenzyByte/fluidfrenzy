---
title: C# Interaction & Scripting
permalink: /docs/c_interaction_scripting/
---


Fluid Frenzy exposes a static API on `FluidFrenzy.FluidSimulationManager` for querying and modifying all registered [Fluid Simulation](../fluid_simulation_components#fluid-simulation) components in the scene. Each call iterates every active simulation and applies the operation where the world position falls inside that simulation's bounds.

The manager is driven automatically by `FluidSimulationLoop`, which hooks into Unity's player loop (FixedUpdate by default, or Update when `FLUIDFRENZY_RUN_UPDATE` is defined). You normally do not call `Step` yourself unless you are building a custom integration.

<a name="fluid-simulation-manager"></a>
### Fluid Simulation Manager

#### Simulation control

```c#
FluidSimulationManager.simulations          // List<FluidSimulation> of all registered sims
FluidSimulationManager.globalTimeScale      // float multiplier for all sim time (script-only)
FluidSimulationManager.Step(deltaTime, maxSteps)
FluidSimulationManager.MarkSettingsChanged(bool changed)
FluidSimulationManager.RequestObstacleUpdate(bool changed)
```

`Step` advances every registered simulation, runs solid-to-fluid coupling on [Fluid RigidBody](../fluid_simulation_components#fluid-rigidbody) instances, and updates cull/pause state from active game cameras. `MarkSettingsChanged` and `RequestObstacleUpdate` broadcast to all simulations when shared settings or obstacle geometry change at runtime.

#### Adding fluid

```c#
AddFluid(Vector3 worldPos, Vector2 size, float amount, float falloff, int layer, float timestep)
```

Adds fluid in a circular region at the specified world position and size. `layer` selects the fluid layer index. `falloff` controls the radial gradient. `timestep` is the delta time for this application (typically `Time.deltaTime`).

#### Applying flow and forces

```c#
ApplyFlow(Vector3 worldPos, Vector2 direction, Vector2 size, float strength, float falloff, float timestep)
ApplyFlowVortex(Vector3 worldPos, Vector2 size, float innerStrength, float outerStrength, float timestep)
ApplyForce(Vector3 worldPos, Vector2 direction, Vector2 size, float strength, float falloff, float timestep, bool splash)
ApplyForceVortex(Vector3 worldPos, Vector2 size, float strength, float falloff, float timestep)
ApplyForce(Texture texture, float strength, float timestep)
```

These mirror [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) behaviors programmatically. Flow methods write to the velocity field; force methods displace the height field. Set `splash` to true on `ApplyForce` for an outward radial impulse instead of a directional push. The texture overload applies a red-channel height/force mask in simulation UV space.

#### Sampling the simulation

##### Height & velocity

```c#
bool GetHeight(Vector3 worldPos, out Vector2 heightData)
bool GetHeightLayer(Vector3 worldPos, out Vector2 heightData, out int layer)
bool GetHeightVelocity(Vector3 worldPos, out Vector2 heightData, out Vector3 velocity)
```

Samples height and/or velocity at the specified world space position when inside a simulation's bounds.

- `heightData.x` contains the total height in world space, including the height of the underlying terrain.
- `heightData.y` contains depth of the fluid in relation to the underlying terrain.
- `velocity` contains the fluid velocity in world space.
- `GetHeightLayer` also returns the dominant (highest) fluid layer index at that point.

Returns `false` when no simulation contains the position or no valid data is available.

##### Normals

```c#
bool GetNormal(Vector3 worldPos, out Vector3 normal)
```

Samples the world-space surface normal at the specified position.

##### Distance field

```c#
bool GetNearestFluidLocation2D(Vector3 worldPos, out Vector3 fluidLocation)
bool GetNearestFluidLocation3D(Vector3 worldPos, out Vector3 fluidLocation)
```

Samples the fluid distance field to find the nearest location containing fluid.

- **2D** returns the nearest XZ location from the distance field; Y is copied from `worldPos.y`. Use this when you will sample other data at that horizontal location.
- **3D** returns the nearest location including the fluid surface height. Useful for placing audio sources or markers directly on the water line.

##### Example

This script places a GameObject containing an AudioSource at the nearest fluid location relative to the object. Attach it to a camera or player.

```c#
public class FluidFinder : MonoBehaviour
{
    public GameObject audioSource;

    void Update()
    {
        FluidFrenzy.FluidSimulationManager.GetNearestFluidLocation3D(transform.position, out Vector3 location);
        audioSource.transform.position = location;
    }
}
```

---

<div style="page-break-after: always;"></div>

<a name="using-shadergraph"></a>
