---
title: Fluid Frenzy Toolbar
permalink: /docs/fluid_frenzy_toolbar/
---


<a name="fluid-toolbar"></a>

The **Fluid Frenzy Toolbar** is a dedicated overlay for the Unity Scene View, designed to streamline fluid simulation, terrain, terraform, and obstacle modifier placement. It features a responsive UI that adapts to both horizontal and vertical layouts depending on your Scene View dimensions.

<video controls autoplay loop muted style="max-width: 100%; height: auto;">
  <source src="../../assets/images/toolbar_docs.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

### Accessing the Toolbar

To enable the toolbar in your Scene View, right-click on the Scene View tab (or the Overlay menu icon), navigate to **Overlays**, and select **Fluid Frenzy > Level Design**. (The overlay was previously listed as **Fluid Frenzy > Toolbar**.) This strip holds Sculpt Mode, Modifier Mode, and the shared layer and brush controls.

Simulation preview transport lives on a second overlay: **Fluid Frenzy > Simulation Preview**. You can enable both overlays on the same Scene View and dock them where you like. They are independent so preview controls do not crowd the sculpt UI.

<a name="toolbar-simulation-preview"></a>
### Simulation Preview

The **Simulation Preview** overlay includes Play, Pause, Stop, and Reset for [Edit Mode Preview](../simulation_debugger#edit-mode-preview). These controls match *Window > Fluid Frenzy > Preview Simulation* and the Preview button on the [Fluid Simulation](../fluid_simulation_components#fluid-simulation) inspector. They are available while you use Sculpt Mode or Modifier Mode on **Level Design**. Stop preview before sculpting so the simulation is not using the live terrain textures.

| Control | Action |
| :--- | :--- |
| **Play** | Starts the simulation in Edit Mode. If no simulations are enabled, every loaded simulation is started. |
| **Pause** | Pauses the simulation. GPU resources stay allocated and the water stays frozen in place. |
| **Stop** | Stops the simulation and releases GPU resources. Terraform and erosion terrain return to the maps stored in Terrain Data. Preview is session-only and is not saved with the scene. |
| **Reset** | Resets the water on simulations that are currently previewing. |

Preview is disabled while Unity is in Play Mode. The solver then runs from Play Mode as usual.

### Modes

The toolbar is divided into two primary modes of operation. You can switch between them using the toggle buttons located at the start of the toolbar.

<a name="toolbar-level-design"></a>
#### Sculpt Mode

Sculpt Mode paints heightmaps and splat layers directly onto [Simple Terrain](../terrain#simple-terrain) and [Terraform Terrain](../terrain#terraform-terrain) in the Scene View. Your edits are saved with the scene in the Terrain Data asset. This is for building the level in the editor. Changes from the [Erosion Layer](../fluid_simulation_components#erosion-layer) or [Terrain Modifier](../fluid_simulation_components#terrain-modifier) during [Edit Mode Preview](../simulation_debugger#edit-mode-preview) or Play Mode are separate.

The same brushes, tools, and sliders appear on the terrain inspector **Paint** tab. Changing **Size** on the toolbar updates the inspector immediately, and the reverse is true. Size and Strength **slider ranges** (min/max on the folded-out sliders on **Paint**) persist per project in `ProjectSettings/Packages/com.frenzybyte.fluidfrenzy/LevelDesignSliders.asset`. The active brush texture is remembered for the editor session (including after a domain reload).

**When you can sculpt**

- Unity must be in **Edit Mode** (not Play Mode).
- [Edit Mode Preview](../simulation_debugger#edit-mode-preview) must be **stopped** so the simulation is not owning the live heightmap.
- Sculpt input is enabled when **Level Design** is visible, Sculpt Mode is on, **or** when a terrain is selected and the inspector **Paint** tab is open.

While you work, the Scene View shows a **cursor preview** of the brush footprint on the terrain. Press **G** to switch to **live mesh preview**, which deforms the terrain mesh to show the result of the brush before you click (helpful for Set, Min, Max, and cliff shapes). Press **G** again to return to the lighter cursor preview.

**Choosing a brush**

Click the **brush** thumbnail on the toolbar to open a popup grid of stamp textures. Pick any thumbnail to use it for the next strokes. The list matches the scrollable palette on the **Paint** tab. Package brushes are soft gaussian falloffs. You can add project folders under **Scan Folders** on **Paint** (see [Brush stamps](../terrain#terrain-brush-stamps)). Only the **red channel** of the texture is used as the brush shape. Rotate the stamp with **Rot** or **Alt + scroll**.

| Button | Tool | Summary |
| :---: | :--- | :--- |
| **+** | Raise or Lower | Add or subtract height on the selected layers. Hold **Ctrl** (Windows) or **Cmd** (macOS) while painting to lower. |
| **Sm** | Smooth | Average neighboring heights inside the brush. |
| **Sh** | Sharpen | Emphasize ridges and cliff edges. Adjust **Shrp** (feature sharpness). |
| **=** | Set Height | Blend toward a target height. Stamp black pixels are skipped. |
| **<** | Minimum | Pull height down where it is above the target (digging, shelves). |
| **>** | Maximum | Push height up where it is below the target (plateaus). |
| **Sl** | Slippage | Steep slopes on the **selected layer only** slide downhill and pile at the bottom. Adjust **Ang** (rest angle in degrees). |
| **L / W** | Height space | **L** = local layer thickness. **W** = world surface height (Set, Min, Max only). |

**Scene View shortcuts (sculpt)**

| Input | Action |
| :--- | :--- |
| **Left drag** | Paint a stroke (one undo group per stroke). |
| **Ctrl / Cmd + drag** | Lower while **+** is selected. |
| **Ctrl / Cmd + scroll** | Brush **Size** (diameter in world units). |
| **Shift + scroll** | Brush **Strength** (**Str**, 0–100). |
| **Alt + scroll** | Brush **Rotation** (**Rot**). |
| **G** | Toggle live mesh preview vs cursor preview. |
| **Alt + drag** | Does not paint (Alt is used for rotation via scroll). |

For full tool descriptions, layers, splat painting, and custom brushes, see [Terrain sculpting and painting](../terrain#terrain-sculpting).

#### Modifier Mode
This mode provides a drag-and-drop palette for placing simulation and layout objects. To use these tools, simply click and drag an icon from the toolbar directly into the Scene View to spawn the object at that location.

| Icon | Component |
| :---: | :--- |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-source.png" width="40" /> | [Fluid Source](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-wave.png" width="40" /> | [Fluid Force](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-current.png" width="40" /> | [Fluid Current](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-path.png" width="40" /> | [Fluid Path](../fluid_modifiers#fluid-modifier-path) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-vortex.png" width="40" /> | [Fluid Vortex](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-terrain-source.png" width="40" /> | [Terrain Modifier](../fluid_simulation_components#terrain-modifier) |
| <img src="../../assets/images/icons/icons-toolbar-mod-sediment.png" width="40" /> | [Sediment Modifier](../fluid_simulation_components#sediment-modifier) |
| <img src="../../assets/images/icons/icons-toolbar-mod-terraform.png" width="40" /> | [Terraform Modifier](../fluid_simulation_components#terraform-modifier) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-cube.png" width="40" /> | [Obstacle Cube](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-sphere.png" width="40" /> | [Obstacle Sphere](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-cylinder.png" width="40" /> | [Obstacle Cylinder](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-elipse.png" width="40" /> | [Obstacle Elipse](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-wedge.png" width="40" /> | [Obstacle Wedge](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-hexprism.png" width="40" /> | [Obstacle HexPrism](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-cone.png" width="40" /> | [Obstacle Cone](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-capsule.png" width="40" /> | [Obstacle Capsule](../fluid_simulation_components#fluid-simulation-obstacle) |

### Shared Settings

The settings panel allows you to configure properties that apply to the object being dragged or the brush being used.

#### Terrain or Fluid Layer
Selects the target layer for the operation (1–8). When placing a **Fluid Source**, only layers 1 and 2 are supported. For terrain operations, this corresponds to the specific erosion layer being modified. Layers 5–8 write the second heightmap when [eight-layer terrain](../terrain#eight-layer-terrain) is enabled. In Sculpt Mode, toggles which heightmap channels receive the stroke. Turn all layers off to paint splat only. **Click** a layer to select **only** that layer. **Ctrl/Cmd-click** toggles a layer on or off without clearing the others. The solo (eye) control hides layers above the highest selected layer in the Scene View preview only.

#### Splat Channels
Selects the specific color channel (Red, Green, Blue, or Alpha) to modify. This setting is strictly for **Terrain Modifiers** and is only active when Layer 1 is selected. It has no effect on Fluid Modifiers or Obstacles. In Sculpt Mode on **Terraform Terrain**, the R/G/B/A buttons paint that splat channel (click again to clear). They are disabled for Smooth, Sharpen, and Slippage.

#### Blend Mode
Determines how the tool interacts with existing data. **Additive** adds value to the current height or strength. **Set** overrides the current value with the specific setting. **Minimum** blends by taking the lowest value between the modifier and the existing data (useful for digging). **Maximum** blends by taking the highest value (useful for raising).

In Sculpt Mode, the sculpt tool buttons select the operation directly: **+** uses Additive, **=** / **<** / **>** use Set / Minimum / Maximum. Smooth, Sharpen, and Slippage use their own operators (not this blend picker).

#### Tool Properties
These sliders adjust the physical properties of the object being spawned. **Size** controls the initial scale of the spawned object or the radius of the brush. **Str** (Strength) controls the intensity or opacity of the modifier. **Rot** (Rotation) applies an initial Y-axis rotation (0–360°) to the object.

In Sculpt Mode, **Size** is the brush **diameter** in world units. **Str** is how strong each tool paints. Raise, Smooth, and Slippage feel different at the same **Str**. Set, Min, and Max use **Str** as how hard you push toward the target height. **Rot** spins the stamp texture. **Shrp** appears when Sharpen is selected. **Ang** appears when Slippage is selected. Use **Ctrl/Cmd + scroll**, **Shift + scroll**, and **Alt + scroll** in the Scene View to change Size, Strength, and Rotation without using the sliders.


---

<div style="page-break-after: always;"></div>

<a name="fluid-simulation-components"></a>
