---
title: Fluid Modifiers
permalink: /docs/fluid_modifiers/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

**Fluid Modifiers** are *Components* that can be attached to a *GameObject*. They are used to interact with the simulation in multiple ways, ranging from adding/removing fluids and applying forces. There are several **Fluid Modifier** types each with specific behaviors.

<a name="fluid-modifier-volume"></a>
### Fluid Modifier Volume

**Fluid Modifier Volume** has multiple types that can be used simultaneously. The types are:

![Fluid Modifier Volume](../../assets/images/fluidsource.png)

<a name="fluid-volume-source"></a>
#### Source

Is used to add/remove fluid from the simulation.
- **Mode** - sets the input mode of the modifier.
    Options:
    - *Circle* - the modifier inputs the fluid in a circular shape.
    - *Box* - the modifier inputs fluid in a rectangular shape.
    - *Texture* - the modifier inputs the fluid from a source texture.
 - **BlendMode** - set the blend mode of the modifier
    Options:
    - *Set:* replaces the current fluid height.
    - *Additive:* adds or removes fluid height.   
    - *Minimum*: prevents the fluid from exceeding this height.
- **Dynamic** - enables/disables if the modifier can be moved. When disabled the modifier will write to a static texture at the start of the simulation. This is useful if you have many fluid sources and want to improve your performance.
- **Size** - adjusts the size of the volume in world space.
- **Strength** - adjusts the amount of fluids input by the volume
- **Falloff** - Adjusts the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create large but more focused fluid sources. A higher value means the source strength falls off faster.
- **Texture** - the texture to use as an input. Only the red channel is used.
- **Layer** - the layer to add the fluids to.

<a name="fluid-volume-flow"></a>
#### Flow

is used to add a force to the velocity field of the simulation. An example of this would be a boat's motor pushing away foam or a whirlpool.

- **Mode** - is the input mode of the modifier.
    Options:
    - *Circle* - the modifier inputs the flow in a direction within a circular shape.
    - *Vortex* - the modifier inputs the flow of a vortex. The flow shape will be circular but has control over the radial flow and the inward flow
    - *Texture* - the modifier inputs the flow direction from a flow map texture.
- **Direction** - is the 2D direction that the flow force will be applied in. On a flat surface `direction.x` is in X world space and `direction.y` is Z in world space. If the surface is sloped either component will appear to go more in the world space Y since the velocity field is in 2D. 
- **Size** - adjusts the size of the flow volume in world space.
- **Strength** adjusts the amount of flow applied to the velocity field. For Vortex mode, this is the inward flow to the center.
- **Falloff** - adjusts the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create sharper/flatter wave/vortex shapes. Higher values mean a faster falloff.
- **Radial Flow Strength** - adjusts the amount of radial flow applied to the velocity field for vortex mode. Higher values make vortices flow faster.
- **BlendMode** - set the mode used to blend in the velocity to the simulation*Set:* replaces the current flow of the velocity field.
    Options:
    - *Set:* replaces the current flow of the velocity field.
    - *Additive:* adds the flow to the current flow in the velocity field. 
- **Texture** -  flow map texture that writes its red & green channels into the velocity field. This texture is unpacked from 0 to 1 range to -1 to 1 range, so anything below 0.5 will be left/down and anything above will be right/up. For more information see: https://catlikecoding.com/unity/tutorials/flow/texture-distortion/

<a name="fluid-volume-force"></a>
#### Force

Is used to add a displacement force to the simulation. There are several types of forces ranging from waves, splashes and whirlpools.

- **mode** sets the input mode of the modifier.
    Options:
    - *Circle* - creates a force in a direction within a circular shape. This is useful for creating waves and pushing fluids around.
    - *Vortex* - create a force that moves fluids down with a distance-based falloff, creating a vortex/whirlpool-like shape.
    - *Splash* - creates a splash effect on the fluid surface. Pushes fluids in an outward direction from the center so that the simulation can move it back in, causing a splash effect.
    - *Texture* - creates forces from a texture input. The red channel of this texture will be used as a height displacement. This can be used to create multiple fluid effects in one drawcall.
- **Size** - adjusts the size of the modifier in world space.
- **Direction** - is the direction the applied force causes the waves to move in. `direction.x` is X in world space and `direction.y` is Z in world space.
- **Strength** - the height of the wave/splash, the depth of the vortex, or the strength to apply the supplied texture.
- **Falloff** - adjusts the curve of the distance-based strength to fall off faster/slower when the distance from the center is greater. Use this to create sharper/flatter wave/vortex shapes. Higher values mean a faster falloff.
- **Texture** - the texture to use as an input into the outflow texture. Only the red channel is as a height used. 

<a name="fluid-modifier-waves"></a>
### Fluid Modifier Waves

**Fluid Modifier Waves** applies a displacement force to the simulation to replicate waves generated by external forces like wind. 

![Fluid Modifier Waves](../../assets/images/fluidmodifier_waves.png)

- **Strength** - the amount of force to be applied in regions where waves are being generated.
- **Wave Count** - the number of waves/octaves to generate. Each wave will be a value between the following ranges below.
    - *Wavelength* - the range of possibly sizes for the waves
    - *Direction* - the directions the waves should be traveling in in degrees.
    - *Amplitude* - the amplitude/height of the waves.
    - *Speed* - generate waves based on a noise texture to break up repeating patterns. The height of small noise waves.
= **Noise Amplitude** - noiseAmplitude

<a name="fluid-modifier-pressure"></a>
### Fluid Modifier Pressure

**Fluid Modifier Pressure** applies a displacement force to the simulation based on the pressure generated by the velocity field. Areas of high pressure where fluid pushes against an obstacle like terrain or object will become elevated making the fluid field appear like it is accumulating before spreading around the obstacle. 
*Note: for this modifier to function the simulation needs to use additive velocity mode in the [Fluid Simulation Settings](../fluid_simulation_components#flux-fluid-simulation-settings)*.

![Fluid Modifier Pressure](../../assets/images/fluidmodifier_pressure.png)

- **Pressure Range** - is the range at which the pressure is high enough to start applying forces to the fluid simulation. Any pressure below the minimum value will apply no forces, and anything above the maximum will apply the full strength. Anything in between is interpolated using [smoothstep](https://en.wikipedia.org/wiki/Smoothstep).
- **Strength** - is the amount of force to be applied when there is enough pressure built up in the fluid simulation.

<a name="foam-modifier"></a>
### Foam Modifier

The **Foam Modifier** component adds and removes foam to the **Foam Layer** based on settings and transform of the object. 
![foammodifier](../../assets/images/foammodifier.png)

- **Strength** - adjusts the amount of foam to add or remove.
- **exponent** - the falloff/shape of the foam added.
- **size** - adjusts the size/area that is covered by the modifier to add foam in that region.

---

<div style="page-break-after: always;"></div>

<a name="interaction-scripting"></a>
