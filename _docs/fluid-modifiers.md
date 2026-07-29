---
title: Fluid Modifiers
permalink: /docs/fluid_modifiers/
---


[Fluid Modifier](../terrain#fluid-modifier) are Components that can be attached to a GameObject. This is the base class other [Fluid Modifier](../terrain#fluid-modifier) (can) derive from and can be used to write custom interactions with the [Fluid Simulation](../fluid_simulation_components#fluid-simulation) They are used to interact with the simulation in multiple ways, ranging from adding/removing fluids and applying forces. There are several Fluid Modifier types each with specific behaviors.

<a name="fluid-modifier-volume"></a>
### Fluid Modifier Volume

[Fluid Modifier Volume](#fluid-modifier-volume) is a FluidModifier that interacts with any [Fluid Simulation](../fluid_simulation_components#fluid-simulation). There are several modes that can be used to interact with fluid simulations by setting the Fluid Modifier Type.

![Fluid Modifier Volume](../../assets/images/fluidsource.png)

| Property | Description |
| :--- | :--- |
| Type | Specifies the type of fluid modification enabled on this volume, which can be a combination of Source, Flow, and Force. |
| [Source Settings](#fluid-source-settings) | Contains all configuration settings for the fluid source behavior when `Type` includes `Source`. |
| [Flow Settings](#fluid-flow-settings) | Contains all configuration settings for the fluid flow behavior when `Type` includes `Flow`. |
| [Force Settings](#fluid-force-settings) | Contains all configuration settings for the fluid force/wave behavior when `Type` includes `Force`. |

<a name="fluid-source-settings"></a>
#### Fluid Source Settings

Defines the settings when [Source](#source) is enabled on the [Fluid Modifier Volume](#fluid-modifier-volume).

| Property | Description |
| :--- | :--- |
| Mode | Sets the input mode of the modifier, defining the shape or source of the fluid input.<br/><br/>Fluid input modes include:<br/>- **`Circle`** <br/> Fluid input in a circular shape.<br/> <br/>- **`Box`** <br/> Fluid input in a rectangular shape.<br/> <br/>- **`Texture`** <br/> Fluid input defined by a source texture. |
| Dynamic | Enables or disables movement for this modifier.<br/><br/>When disabled, the modifier is treated as static and its contribution is calculated once at the start of the simulation. <br/>This improves performance for multiple stationary fluid sources. |
| Blend Mode | Defines the blending operation used to apply the fluid source to the simulation's height field.<br/><br/>This determines how the fluid is applied to the simulation's current height. Options include:<br/>- **`Additive`** <br/> Adds or subtracts the fluid amount.<br/> <br/>- **`Set`** <br/> Sets the height to a specific value.<br/> <br/>- **`Minimum`/`Maximum`** <br/> Clamps the height to the target value. |
| Space | Specifies the coordinate space to which the fluid height source should be set relative to.<br/><br/>- **[Fluid Simulation](../fluid_simulation_components#fluid-simulation)** <br/> The height is interpreted as a specific world Y-coordinate.<br/> <br/>- **[Fluid Simulation](../fluid_simulation_components#fluid-simulation)** <br/> The height is interpreted relative to the fluid surface's base height. |
| Strength | Adjusts the amount of fluid added or set by the volume.<br/><br/>- **For Additive blending** <br/> This is the rate per second of fluid to add/subtract.<br/> <br/>- **For Set blending** <br/> This value contributes to the target height. |
| Falloff | Adjusts the curve of the distance-based strength, controlling how quickly the influence falls off from the center.<br/><br/>Higher values create a faster falloff, resulting in a more focused fluid source. |
| Target Layer | Specifies the target fluid layer to which the fluid will be added. |
| Size | Adjust the size (width and height) of the modification area in world units. |
| Source Texture | The source texture used to determine the shape and intensity of the fluid input when `Mode` is `Texture`. <br/>Only the red channel of the texture is used. |

<a name="fluid-flow-settings"></a>
#### Fluid Flow Settings

Defines the settings when [Flow](#flow) is enabled on the [Fluid Modifier Volume](#fluid-modifier-volume).

| Property | Description |
| :--- | :--- |
| Mode | Sets the input mode of the modifier, defining how flow is applied.<br/><br/>Flow application modes include:<br/>- **`Circle`** <br/> A constant directional flow within a circular shape.<br/> <br/>- **`Vortex`** <br/> A circular flow with radial and tangential control.<br/> <br/>- **`Texture`** <br/> Flow direction supplied from a dedicated flow map texture. |
| Direction | Sets the 2D direction in which the flow force will be applied for `Circle`.<br/><br/>The `x` component maps to world X, and the `y` component maps to world Z (assuming a flat surface). |
| Blend Mode | The blending operation used to apply the generated velocity to the simulation's velocity field.<br/><br/>This determines how the velocity is applied to the simulation's current flow. Options include:<br/>- **`Additive`** <br/> Adds or subtracts the flow/velocity amount.<br/> <br/>- **`Set`** <br/> Sets the flow/velocity to a specific vector.<br/> <br/>- **`Minimum`/`Maximum`** <br/> Clamps the velocity vector components to the target values. |
| Strength | Adjusts the magnitude of the flow applied to the velocity field.<br/><br/>For `Vortex` mode, this specifically controls the *inward* flow to the center. |
| Radial Flow Strength | Adjusts the amount of *tangential* flow applied for `Vortex` mode. <br/>Higher values create a faster spinning vortex. |
| Falloff | Adjusts the curve of the distance-based strength, controlling how quickly the influence falls off from the center.<br/><br/>Higher values create a sharper shape with faster falloff. |
| Size | Adjust the size (width and height) of the modification area in world units. |
| Texture | The flow map texture used as input when `Mode` is `Texture`.<br/><br/>The texture's Red and Green channels map to the X and Y velocity components. The texture is unpacked from the [0, 1] range to the [-1, 1] velocity range. |

<a name="fluid-force-settings"></a>
#### Fluid Force Settings

Defines the settings when [Force](#force) is enabled on the [Fluid Modifier Volume](#fluid-modifier-volume).

| Property | Description |
| :--- | :--- |
| Mode | Sets the input mode of the modifier, defining the type of force applied.<br/><br/>Force application modes include:<br/>- **`Circle`** <br/> A directional force within a circular shape (for waves/pushes).<br/> <br/>- **`Vortex`** <br/> A downward, distance-based force (for whirlpools).<br/> <br/>- **`Splash`** <br/> An immediate outward force (for splash effects).<br/> <br/>- **`Texture`** <br/> Forces created from a texture input. |
| Blend Mode | The blending operation used to apply or dampen the force in the simulation.<br/><br/>This determines how the force is applied to the simulation. Options include:<br/>- **`Additive`** <br/> Adds or subtracts the force amount.<br/> <br/>- **`Set`** <br/> Sets the force to a specific vector.<br/> <br/>- **`Minimum`/`Maximum`** <br/> Clamps the force vector components to the target values. |
| Direction | Sets the 2D direction of the applied force/wave propagation.<br/><br/>The `x` component maps to world X, and the `y` component maps to world Z (assuming a flat surface). |
| Strength | Controls the magnitude of the force applied.<br/><br/>This represents the height of the wave/splash, the depth of the vortex, or the strength to apply the supplied texture. |
| Falloff | Adjusts the curve of the distance-based strength, controlling how quickly the influence falls off from the center.<br/><br/>Higher values create a sharper shape with faster falloff. |
| Size | Adjust the size (width and height) of the modification area in world units. |
| Texture | The source texture used as an input when `Mode` is `Texture`. <br/>Only the red channel is used for height/force displacement. |


<a name="fluid-modifier-waves"></a>
### Fluid Modifier Waves

A specialized [Fluid Modifier](../terrain#fluid-modifier) that generates procedural wave forces to simulate wind-driven water surfaces.

This component stacks multiple layers of waves (octaves) with varying properties to create complex, non-repetitive surface motion. It generates forces that displace the fluid, creating the visual and physical appearance of waves.

![Fluid Modifier Waves](../../assets/images/fluidmodifier_waves.png)

| Property | Description |
| :--- | :--- |
| Strength | A global multiplier applied to the total force calculated from all wave octaves. |
| Octave Count | The number of individual wave layers (octaves) to generate and stack.<br/><br/>Each octave is randomly generated based on the ranges defined below. <br/>Increasing this count adds more detail and complexity to the surface but increases the computational cost. |
| Wave Length Range | Defines the minimum and maximum wavelength (physical size) for the generated octaves.<br/><br/>- **X (Min)** <br/> The smallest allowed wavelength (tight ripples).<br/> <br/>- **Y (Max)** <br/> The largest allowed wavelength (broad swells). |
| Direction Range | Defines the angular range (in degrees) for the propagation direction of the waves.<br/><br/>- **X (Min)** <br/> The minimum angle in degrees.<br/> <br/>- **Y (Max)** <br/> The maximum angle in degrees.<br/> <br/><br/>Use this to restrict waves to a specific wind direction or allow them to move chaotically in all directions. |
| Amplitude Range | Defines the minimum and maximum height intensity for the generated octaves.<br/><br/>- **X (Min)** <br/> The lowest possible amplitude for an octave.<br/> <br/>- **Y (Max)** <br/> The highest possible amplitude for an octave. |
| Speed Range | Defines the minimum and maximum phase speed (travel speed) for the generated octaves.<br/><br/>- **X (Min)** <br/> The slowest speed a wave can travel.<br/> <br/>- **Y (Max)** <br/> The fastest speed a wave can travel. |
| Noise Amplitude | Controls the intensity of the secondary Perlin noise layer.<br/><br/>A noise layer is applied on top of the wave octaves to break up mathematical patterns and add organic irregularity to the surface.<br/>Higher values result in a more chaotic surface. |
| Perlin Noise Scale | Controls the spatial frequency (tiling) of the secondary Perlin noise layer.<br/><br/>- **High Values** <br/> Creates high-frequency noise, resulting in small, detailed surface disturbances.<br/> <br/>- **Low Values** <br/> Creates low-frequency noise, resulting in large, broad variations. |

<a name="fluid-modifier-pressure"></a>
### Fluid Modifier Pressure

A specialized [Fluid Modifier](../terrain#fluid-modifier) that applies vertical displacement forces based on the internal pressure of the fluid.

This component simulates the physical phenomenon where fluid "piles up" when colliding with obstacles or terrain. It creates localized elevation in high-pressure zones, effectively bulging waves and dips. 

 *Requirement: This modifier relies on pressure field data, which is only calculated by the [Flux Fluid Simulation](../fluid_simulation_components#flux-fluid-simulation). This component will have no effect if used with a [Flow Fluid Simulation](../fluid_simulation_components#flow-fluid-simulation).*

*Note: for this modifier to function the simulation needs to use additive velocity mode in the [Fluid Simulation Settings](../fluid_simulation_components#flux-fluid-simulation-settings)*.

![Fluid Modifier Pressure](../../assets/images/fluidmodifier_pressure.png)

| Property | Description |
| :--- | :--- |
| Pressure Range | Defines the pressure threshold range for applying displacement forces.<br/><br/>- **X (Min)** <br/> Pressure values below this threshold generate no displacement.<br/> <br/>- **Y (Max)** <br/> Pressure values above this threshold apply the full displacement strength.<br/> <br/><br/>Intermediate values are interpolated using Smoothstep. |
| Strength | A global multiplier applied to the displacement force in high-pressure regions.<br/><br/>Higher values result in more exaggerated peaks where the fluid accumulates against obstacles. |

<a name="foam-modifier"></a>
### Foam Modifier

The **Foam Modifier** component adds and removes foam to the **Foam Layer** based on settings and transform of the object. 
![foammodifier](../../assets/images/foammodifier.png)

| Property | Description |
| :--- | :--- |
| Strength | The amount of foam to add or remove |
| Exponent | The falloff/shape of the foam added. |
| Size | The size/area that is covered by the modifier to add foam in that region. |

---

<div style="page-break-after: always;"></div>

<a name="interaction-scripting"></a>
