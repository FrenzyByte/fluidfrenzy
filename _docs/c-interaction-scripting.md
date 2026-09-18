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

<a name="creating-simulations-modifiers-obstacles"></a>
### Creating simulations, modifiers, and obstacles

`FluidSimulationManager` is the query and one-shot brush API. To spawn persistent objects (the same types the Scene View toolbar places), call `Create` on the component types. These methods work in play mode and in the editor. Created components register themselves in `OnEnable`, so every active simulation picks them up.

#### Simulations

```c#
FlowFluidSimulation sim = FluidSimulation.Create(
    settings, position, Quaternion.identity, terrain);

sim.AddFluidLayer<FluidFlowMapping>();
```

`Create` without a type argument uses Flow. Flux still works through `FluidSimulation.Create<FluxFluidSimulation>(...)`.

`settings` must be assigned before the simulation can `Init` (that happens from `Start`, or call `Init` yourself if you need GPU resources the same frame). `terrain` is optional and is passed to `SetTerrain` (Unity `Terrain`, `SimpleTerrain`, `Texture2D`, or `MeshCollider`).

#### Surfaces

You still need a material. These methods only spawn and wire the renderer.

```c#
WaterSurface.Create(sim, waterMaterial, flowMapping);
LavaSurface.Create(sim, lavaMaterial, flowMapping, sim.transform, "Fluid Renderer");
```

Pass parent as null (or omit it) to add the component on the simulation GameObject. Pass a parent transform to spawn a child renderer.

#### In-memory settings

At runtime, create layer or simulation settings without writing assets:

```c#
FoamLayerSettings foam = FluidSettingsFactory.Create<FoamLayerSettings>(s => { /* optional */ });
FoamLayerSettings copy = FluidSettingsFactory.Duplicate(existingAsset);
```

#### Extension layers

Prefer these over raw `AddFluidLayer` when you need settings assigned in one call:

```c#
sim.AddFoamLayer(existingFoamSettings);
sim.AddFlowMapping(configure: s => s.flowMappingMode = FluidFlowMapping.FlowMappingMode.Static);
sim.AddWetnessLayer();
sim.AddErosionLayer();
sim.AddTerraformLayer();
sim.AddParticleGenerator(generator => { /* tune cascades, materials, etc. */ });
```

Pass `null` for settings to get a new in-memory instance from `FluidSettingsFactory`.

#### Terraform terrain and simulation

```c#
TerraformTerrain ground = TerraformTerrain.Create(
    position, terrainMaterial, Vector2.one, new Vector2Int(512, 512), parent);

FlowFluidSimulation sim = FluidSimulation.CreateTerraformSimulation(
    ground, waterMaterial, lavaMaterial, initSimulation: true);

// Or with Flux:
FluidSimulation.CreateTerraformSimulation<FluxFluidSimulation>(
    ground, waterMaterial, lavaMaterial);
```

`CreateTerraformSimulation` adds dual-layer fluid settings (or uses your settings asset), foam, static flow, `TerraformLayer`, and water/lava child surfaces. Pass `null` for a material to skip that surface.

#### Editor presets

In the editor, `FluidSimulationMenu` still writes settings assets and default materials. Call the same methods the GameObject menu uses:

```c#
FluidSimulationMenu.CreateWaterSimulation(terrainObject);
FluidSimulationMenu.CreateLavaSimulation(terrainObject);
FluidSimulationMenu.CreateWaterWorldSimulation(terrainObject);
FluidSimulationMenu.CreateTerraformSimulation(terraformTerrainObject);
```

Those wrappers create a Flow simulation. Pass Flux types to the generic overloads if you still need that solver.

Use `FluidSimulation.Create` at runtime when you already have settings and a material. Use the menu presets when you want a new authored sim in the scene.

#### Fluid modifiers

```c#
FluidModifierVolume.CreateSource(position, rotation, size, strength, layer);
FluidModifierVolume.CreateFlow(position, rotation, size, strength);
FluidModifierVolume.CreateForce(position, rotation, size, strength);
FluidModifierVolume.CreateVortex(position, rotation, size);
```

Yaw of `rotation` sets flow and force direction. After create, change the public `sourceSettings` / `flowSettings` / `forceSettings` fields as needed.

#### Terrain and terraform brushes

```c#
TerrainModifier.Create(position, rotation, size, strength, layer, splat);
TerraformModifier.Create(position, rotation, size);
```

`TerrainModifier` needs an `ErosionLayer` on the simulation. `TerraformModifier` needs a `TerraformLayer`.

#### Obstacles

```c#
FluidSimulationObstacle.CreateBox(position, rotation, size);
FluidSimulationObstacle.CreateSphere(position, rotation, radius);
FluidSimulationObstacle.Create(shape, position, rotation, size);
```

Shape helpers also exist for cylinder, ellipsoid, wedge, hex prism, cone, and capsule. Changing an obstacle at runtime still goes through `FluidSimulationManager.RequestObstacleUpdate` when you edit it by hand; `Create` already registers the new object.

---

<div style="page-break-after: always;"></div>

<a name="using-shadergraph"></a>
