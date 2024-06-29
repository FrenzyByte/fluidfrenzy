---
title: Samples
permalink: /docs/samples/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

**Important Info! To prevent project bloat the samples are not imported into your Assets folder by default. Follow the instructions below to import them.**

Fluid Frenzy contains five sample scenes to showcase the functionality and help with understanding how to work with the fluid simulation. You can import the samples using the *Package Manager*. 

1. Open the ```Package Manager```.
<br>![Package Manager Open](../../assets/images/packagemanager_open.png)<br>
2. Select ```In Project```.
3. Select ```Fluid Frenzy``` in the list under **```Packages - Frenzy Byte```**.
4. Go to the ```Samples``` tab.
5. Click the ```Import``` button.
<br>![Package Manager Import Scenes](../../assets/images/packagemanager_importscenes.png)<br>
To run the samples, open any of the scenes in the ```Assets/Samples/Fluid Frenzy/1.0.0/Samples``` folder and click play. Scenes can be loaded at run-time in the **Scenes** tab in the UI. There are several options in the UI *Input Tab* to select from. Control the fluid input type, fluid rigid body spawning, boat driving and "FlyCam". 

![Samples UI](../../assets/images/samples_ui.png)

*Note: The samples optionally use the [Unity Post-Processing package](#https://docs.unity3d.com/Packages/com.unity.postprocessing@3.4/manual/Installation.html) for higher-quality visuals. It will be automatically enabled if the Post-Processing package is imported into the project.*  

<a name="samples-controls"></a>
### Controls

- F1 - select the *Fly Cam* to fly around the scene using the *'WASD'* keys and mouse.
- F2 - select the *Offset Cam* which follows around the *Player Boat*.
- F3 - select the *Third Person Cam* which follows around the *Player Boat*.
- F4 - select the *Smooth Third Person Cam* which follows around the *Player Boat*.
- F5 - select the *Orbit Cam* which orbits around the *Player Boat* and can be controlled with the mouse.
- F6 - enables the *RTS Cam* which can be used to pan over the scene using the *'WASD'* keys.
- 1-5 - select the simulation input mode depending on the scene loaded. 1 Is always water.
- 'WASD' - controls the *Fly Cam*, *RTS Cam*, and the *Player Boat*, allowing you to move forward.
- Arrows - rotates the *Fly Cam* and *RTS Cam*.
- Mouse Left - when held rotates *Fly Cam* and *RTS Cam* when moving the mouse.
- Mouse Right - when held adds the selected fluid/terrain to the simulation at the mouse location.

<a name="samples-river"></a>
### River

![River Sample](../../assets/images/sample_river.png)

The River sample shows the use of [Fluid Modifier Volume](#fluid-modifier-volume) adding water from multiple sources to create three river branches. The camera starts at the end of one of these branches with a boat that can be driven across the scene. Water flows out of the scene due to the *Open Borders* functionality of the fluid simulation to prevent flooding of the scene. This scene makes use of the Unity Terrain so modifying the terrain in realtime- is not possible.

<div style="page-break-after: always;"></div>

<a name="samples-grandcanyon"></a>
### Grand Canyon

![Grand Canyon Sample](../../assets/images/sample_grandcanyon.png)

The Grand Canyon sample shows the use of [Fluid Modifier Volume](#fluid-modifier-volume) adding water from multiple sources on top of the canyon filling the canyon below. The camera starts a boat that can be driven across the scene. Water stays in the scene due to the *Open Borders* functionality of the fluid simulation being disabled causing the scene to eventually flood. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

<a name="samples-watermodifers"></a>
### Water Modifiers

![Water Modifiers Sample](../../assets/images/sample_watermodifiers.png)

The Water Modifiers sample shows the use of [Fluid Modifier Waves](#fluid-modifier-waves) to create different types of waves, [Fluid Modifier Volume](#fluid-modifier-volume) to create a vortex, and [Fluid Rigidbody](#fluid-rigidbody) showcasing buoyancy and advection of objects. The camera starts overlooking the vortex, you can add water and spawn [Fluid Rigid Bodies](#fluid-rigidbody) using the mouse. 

<a name="samples-volcano"></a>
### Volcano

![Volcano Sample](../../assets/images/sample_volcano.png)

The Volcano scene showcases that different fluids can be rendered like lava. This scene uses the [Lava Surface](#lava) [Fluid Renderer](#fluid-rendering-components) to create an erupting volcano. This scene makes use of the Unity Terrain so modifying the terrain in real-time is not possible.

<a name="samples-terraform"></a>
### Terraform

![Terraform Sample](../../assets/images/sample_terraform.png)

The Terraform scene showcases God Game simulation with two types of fluid interacting with each other and erosion of the top sand layer. Water and Lava are automatically added to the scene from different locations and when they touch they turn into rocky terrain and steam. Fluid and Terrain can be added using the mouse input as described in the controls section. This scene makes use of a custom terrain allowing modifications to be made to it in real-time by adding erodible sand, or non-erodible rock and vegetation.

---

<div style="page-break-after: always;"></div>

<a name="setup"></a>
