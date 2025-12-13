---
title: Fluid Frenzy Toolbar
permalink: /docs/fluid_frenzy_toolbar/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

The **Fluid Frenzy Toolbar** is a dedicated overlay for the Unity Scene View, designed to streamline fluid simulation, terrain, terraform, and obstacle modifier placement. It features a responsive UI that adapts to both horizontal and vertical layouts depending on your Scene View dimensions.

<video controls autoplay loop muted>
  <source src="../../assets/images/toolbar_docs.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

### Accessing the Toolbar

To enable the toolbar in your Scene View, right-click on the Scene View tab (or the Overlay menu icon), navigate to **Overlays**, and select **Fluid Frenzy > Toolbar**.

### Modes

The toolbar is divided into two primary modes of operation. You can switch between them using the toggle buttons located at the start of the toolbar.

#### Sculpt Mode (WIP)
**Current Status:** Under Development.

This mode is intended for painting heightmaps and texture layers directly onto the terrain. While the interface currently contains a placeholder Brush Selector, the functional sculpting logic is not yet implemented.

#### Modifier Mode
This mode provides a drag-and-drop palette for placing simulation and layout objects. To use these tools, simply click and drag an icon from the toolbar directly into the Scene View to spawn the object at that location.

| Icon | Component |
| :---: | :--- |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-source.png" width="40" /> | [Fluid Source](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-wave.png" width="40" /> | [Fluid Force](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-current.png" width="40" /> | [Fluid Current](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-fluid-vortex.png" width="40" /> | [Fluid Vortex](../fluid_modifiers#fluid-modifier-volume) |
| <img src="../../assets/images/icons/icons-toolbar-mod-terrain-source.png" width="40" /> | [Terrain Modifier](../fluid_simulation_components#terrain-modifier) |
| <img src="../../assets/images/icons/icons-toolbar-mod-terraform.png" width="40" /> | [Terraform Modifier](../fluid_simulation_components#terraform-modifier) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-cube.png" width="40" /> | [Obstacle Cube](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-sphere.png" width="40" /> | [Obstacle Sphere](../fluid_simulation_components#fluid-simulation-obstacle) |
| <img src="../../assets/images/icons/icons-toolbar-obstacle-cylinder.png" width="40" /> | [Obstacle Cylinder](../fluid_simulation_components#fluid-simulation-obstacle) |

### Shared Settings

The settings panel allows you to configure properties that apply to the object being dragged or the brush being used.

#### Terrain or Fluid Layer
Selects the target layer for the operation (1, 2, 3, or 4). When placing a **Fluid Source**, only layers 1 and 2 are supported. For terrain operations, this corresponds to the specific erosion layer being modified.

#### Splat Channels
Selects the specific color channel (Red, Green, Blue, or Alpha) to modify. This setting is strictly for **Terrain Modifiers** and is only active when Layer 1 is selected. It has no effect on Fluid Modifiers or Obstacles.

#### Blend Mode
Determines how the tool interacts with existing data. **Additive** adds value to the current height or strength. **Set** overrides the current value with the specific setting. **Minimum** blends by taking the lowest value between the modifier and the existing data (useful for digging). **Maximum** blends by taking the highest value (useful for raising).

#### Tool Properties
These sliders adjust the physical properties of the object being spawned. **Size** controls the initial scale of the spawned object or the radius of the brush. **Str** (Strength) controls the intensity or opacity of the modifier. **Rot** (Rotation) applies an initial Y-axis rotation (0–360°) to the object.


---

<div style="page-break-after: always;"></div>

<a name="fluid-simulation-components"></a>
