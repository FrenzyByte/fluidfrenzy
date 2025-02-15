---
title: Setup
permalink: /docs/setup/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

Fluid Frenzy is easy and quick to set up ready for use with just a few clicks. To set up a scene to use Fluid Frenzy follow the steps below:
<sub>*Note that Fluid Frenzy has two Fluid Simulation methods called **Flux** and **Flow** and the is the users choice which version they wish to use.</sub>
<a name="setup-water-simulation"></a>
### Water Simulation

These steps will describe how to set up a fluid simulation that will simulate and render water.

![Water Simulation Setup](../../assets/images/gameobject_fluidfrenzy_watersimulation.png)

1. *(Optional)* Select the Terrain you want to fluid simulation to interact with.
2. Add a [Fluid Simulation](../fluid_simulation_components#fluid-simulation) by clicking the GameObject menu and selecting *`Fluid Frenzy > Flux > Create Water Simulation`* or *`Fluid Frenzy > Flow > Create Water Simulation`*.
3. You should now have a GameObject in your Scene Hierarchy named WaterSimulation with 4 Components:
    - Fluid Simulation
    - Foam Layer
    - Fluid Flow Mapping
    - Water Surface
4. If you followed step 1 go to step 5. The Terrain and its settings have been automatically assigned to the Fluid Simulation Component. If you did not follow step 1 you will have to assign the following fields:
    - Dimension: The size of your simulation/terrain domain.
    - Terrain Type: **Unity Terrain**, **Heightmap**, **Simple Terrain** which specifies the type of terrain you wish to use.
    - Terrain/[Simple Terrain](../fluid_rendering_components#terrain)/Heightmap: The object you want the Fluid Simulation to interact with.
5. Fluid settings, assets, and materials are automatically created in the folder of your scene. You can tweak these values to your liking.
6. Add a [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) by clicking the GameObject menu and selecting *`Fluid Frenzy > Fluid Source`*.
7. Setup the new Fluid Modifier by placing it in the desired location in the scene and setting up the settings in the Inspector

You now have a functional Fluid Simulation using Fluid Frenzy. Hit Play and see your Terrain being flooded by water!


<a name="setup-terraform-simulation"></a>
### Terraform Simulation

![Terraform Simulation Setup](../../assets/images/gameobject_fluidfrenzy_terraform.png)

These steps will describe how to set up a fluid simulation that will simulate god game-like terraforming. The simulation supports fluids of water and lava, erosion and fluid mixing to turn water and lava into rock. In the current version of **Fluid Frenzy** terraforming only works the [Terraform Terrain](../terrain#terraform-terrain).
1. Add a [Terraform Terrain](../terrain#terraform-terrain) to your scene by clicking the GameObject menu and selecting *`Fluid Frenzy > Terraform Terrain`*.
2. Set up your [Terraform Terrain](../terrain#terraform-terrain) by assigning all required settings.
2. Set up the newly created [Terraform Terrain](../terrain#terraform-terrain) to your liking.
3. Select your [Terraform Terrain](../terrain#terraform-terrain) and add a Terraform Simulation by clicking *`Fluid Frenzy > Flux > Terraform Simulation`* or *`Fluid Frenzy > Flow > Terraform Simulation`*.
5. Fluid settings, assets, and materials are automatically created in the folder of your scene. You can tweak these values to your liking.
6. Add a [Fluid Modifier Volume](../fluid_modifiers#fluid-modifier-volume) by clicking the GameObject menu and selecting *`Fluid Frenzy > Fluid Source`*.
7. Set up the new Fluid Modifier by placing it in the desired location in the scene and setting up the settings in the Inspector. You can change the layer to control which fluid the modifier should add to. Layer 1 is Water while Layer 2 is Lava.

You now have a functional Terraform Simulation using Fluid Frenzy. Hit Play and see your Terrain being filled with water and lava!

<a name="setup-urp"></a>
### Universal Render Pipeline

Fluid Frenzy supports seamless integrating with Unity's [Universal Render Pipeline](https://unity.com/srp/universal-render-pipeline).
Almost all simulation and rendering components are interchangeable between Built-in and URP without having to assign new shaders or materials.
The following features require configuration changes of the [Universal Render Pipeline Asset](https://docs.unity3d.com/6000.0/Documentation/Manual/urp/universalrp-asset.html).

- #### Screenspace Refraction
    When **Screenspace Refraction** is enabled on the FluidFrenzy/Water shader/material URP requires the following setting to be enabled:
    ![URP Opaque Texture](../../assets/images/urp_opaque_texture.png)

---

<div style="page-break-after: always;"></div>

<a name="fluid-simulation-components"></a>
