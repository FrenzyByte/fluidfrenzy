---
title: Multiplayer Support (Beta)
permalink: /docs/multiplayer_support_beta/
---


Multiplayer support is a **beta** feature. Fluid Frenzy can keep solver state close across players. It does not ship Netcode for GameObjects, Mirror, Photon, or any other network library. You pick the netcode. Fluid Frenzy gives you a shared clock and a solver snapshot to send on that netcode.

The components, snapshot format, and this workflow may change in future versions. If you encounter any bugs, issues, or have suggestions, please report them [here](https://github.com/FrenzyByte/fluidfrenzy/issues).

The C# calls live on `FluidSimulation` and `FluidSimulationManager`. See [Multiplayer hooks](../c_interaction_scripting#multiplayer-hooks) for the API list and a copy-paste example.

<a name="multiplayer-possible"></a>
### What is possible

The idea is host-authoritative **solver** state, not lockstep water.

- **Late join.** A player who arrives mid-session can load the current flood, river, and carved terrain instead of starting from the initial water height.
- **Shared clock.** Every peer writes the same session time. The solver then takes the same 60 Hz steps. FFT swell and detail waves follow that clock, so the ocean phase matches without putting displacement in the snapshot.
- **Host correction.** The host can capture again later and send a fresh snapshot if the session has drifted too far.
- **Replicated gameplay.** If your netcode already sends "pour here", "enable this modifier", or a boat pose, each peer applies that locally. Fluid Frenzy does not send those events for you.
- **Smaller join packets.** `downsample` 2 or 4 shrinks height and velocity. Terrain in the snapshot stays full resolution.

This is enough for gameplay water. Flooded volume, drowning, and erosion puzzles can match at join time.

<a name="multiplayer-not-possible"></a>
### What is not possible

- **Bit-identical water.** Two GPUs will not produce the same ripple texel for texel. Wakes drift after join.
- **A bundled multiplayer sample.** The [State Sync](../samples#samples-statesync) scene is two simulations in one process. It is not a networked session.
- **Streaming the height field every frame.** Do not send the grid continuously. Capture on join. Capture again only if you need a correction.
- **Networking cosmetics.** Foam, flow mapping, wetness, particles, and FFT displacement are not in the snapshot. They stay local and rebuild from the solver.
- **Networking boats and modifiers.** [Fluid RigidBody](../fluid_simulation_components#fluid-rigidbody) poses, modifier toggles, and scripted brushes are still your game's job.
- **Deterministic Unity physics.** Buoyancy still runs locally. Replicate the rigidbody if the object is networked.
- **Replacing disk Save / Load.** `FluidSimulation.Save` and `Load` write height to a file for tools. They are not a join packet. Use `CreateState` / `LoadState` for multiplayer.

<a name="multiplayer-how-it-works"></a>
### How it works

Each machine runs its own GPU simulation after join. Fluid Frenzy does not step the water on one machine and blit it onto the others every frame.

Your netcode writes `FluidSimulationManager.externalTime`, sends `FluidSimulationState` bytes on join, and replicates pours, modifiers, and rigidbody poses. The manager converts that time into 60 Hz solver steps. FFT and detail waves read the same time. `CreateState` is an async GPU readback of the solver textures. `LoadState` blits them back and resumes from that tick.

**Clock.** Set `useExternalTime` to true and write `externalTime` every frame from your network or session clock. The manager converts that to `floor(externalTime / kMaxTimestep)` steps. At most two solver steps run per player-loop tick. That keeps a hitch from running too many steps at once. `pauseWhenOutOfView` and `pauseWhenFar` are ignored while the clock is on. Local cameras must not pause one peer and not the other. Time scales do not change the step count.

The simulation still updates from Unity's FixedUpdate by default. The clock value is what decides how many 60 Hz steps to take. You can write `externalTime` from FixedUpdate if that matches your netcode tick.

**Snapshot.** `CreateState` reads solver textures from the GPU asynchronously. Height, previous height, and velocity always go in. Flux also stores outflow. An [Erosion Layer](../fluid_simulation_components#erosion-layer) adds live terrain and sediment. A [Terraform Layer](../fluid_simulation_components#terraform-layer) adds the extra terrain and splat. `LoadState` blits those textures back and sets the solver tick from the snapshot.

The snapshot must match the local simulation. Same solver type (Flow or Flux). Same `numberOfCells`. A Flow snapshot will not load onto a Flux sim.

**Events.** After join, a pour only exists on the machine that called `AddFluid`. Send that event yourself, then call `AddFluid` / `ApplyForce` / `AddSediment` on each peer in the same local space. The [State Sync](../samples#samples-statesync) sample does this in one process by applying the pour to both basins.

| Need | How |
| :--- | :--- |
| Same swell / detail-wave phase | Shared `externalTime` |
| Same flood / river / terraform at join | Snapshot with `CreateState` / `LoadState` |
| I splash, you see a splash | Replicate the `AddFluid` event (or the actor) |
| Exact texel of a wake | Out of scope |

<a name="multiplayer-how-to-use"></a>
### How to use it

Every peer needs the same simulation setup before you sync. Same Flow or Flux type. Same resolution. Same dimensions. Same layers you care about in the snapshot.

1. Turn the clock on when the session starts. Every peer writes the same `externalTime`.
2. When a player joins, the host calls `CreateState`.
3. Send `state.ToBytes()` with your netcode. The joiner rebuilds with `FluidSimulationState.FromBytes`.
4. Call `LoadState` on the joiner. Set `FluidSimulationManager.simulationStep` from the snapshot tick before following the host clock.
5. Keep replicating gameplay events. Pours, forces, sediment, modifier toggles, and networked rigidbodies stay on your netcode.

`downsample` 1 is full resolution. Use 2 or 4 on the internet. A 1024 tile is a large join payload. Terrain stays full resolution even when height is downsampled.

Turn the clock on only when every peer writes the same time. A peer that writes `Time.time` while another writes a network tick will drift.

The Fluid Frenzy calls do not change between a local test and a real session. Only the transport changes. Locally you can `LoadState` on a second sim in the same process. On the network you send the bytes.

### State Sync sample

Open `Samples~/StateSync/StateSync.unity`. The scene already has a host and a joiner Flow simulation. This is a local demo. It is not networked multiplayer.

`FluidStateSyncSample` writes a shared clock, copies a snapshot with **C**, and applies pours to both basins in local space. Press **R** to reset the joiner, then **C** again to see a late join. Press **T** to pour on only one basin so they drift. Foam will not match. That is expected.

Use this scene to learn the pattern. Then send the clock, the snapshot bytes, and the pour events with your own netcode.

---

<div style="page-break-after: always;"></div>

<a name="future-updates-roadmap"></a>
