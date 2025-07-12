---
title: C# Interaction & Scripting
permalink: /docs/c_interaction_scripting/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---
Fluid Frenzy offers several methods to interact with the Fluid Simulation on the C# side. It is recommended to use the functions available in FluidSimulationManager.cs
<br>

#### Adding Fluid
Add Fluid to the active Fluid Simulations in the scene at a using the following functions: 

```c#
AddFluid(Vector3 worldPos, Vector2 size, float amount, float falloff, int layer, float timestep)
```
Adds a amount of fluid in at the specified location and size.
<br>

#### Sampling the simulation.
Sample the height and/or velocity data of all Fluid Simulations using the following functions.


##### Height & Velocity
```c#
GetHeight(Vector3 worldPos, out Vector2 heightData)
GetHeightVelocity(Vector3 worldPos, out Vector2 heightData, out Vector3 velocity)
```
*Samples the height and/or velocity at the specified world space position*
- *heightData.x contains the total height in worldspace, including the height of the underlying terrain.*
- *heightData.y contains depth of the fluid in relation to the underlying terrain.*
- *velocity contains the velocity of the fluid.*
<br>

##### Normals

Sample the world space normal vector of the Fluid Simulation using the following functions.

```c#
bool GetNormal(Vector3 worldPos, out Vector3 normal)
```
*Samples the normal at the specified world space position*
<br>
##### Distance Field

Sample the Fluid Simulation distance field using the following functions:


```c#
GetNeartestFluidLocation2D(Vector3 worldPos, out Vector3 fluidLocation)
```
*Samples the fluid distance field to find the nearest fluid location .
Use this function if you want to sample other Fluid Simulation data at the nearest location, for example the velocity to dim the audio of fluid based on the speed of the fluid*

- *fluidLocation The resulting nearest location to worldPos containing fluid in 2D space. The x and z are the location sampled from the distance field. The y is the worldPos.y*

```c#
GetNeartestFluidLocation3D(Vector3 worldPos, out Vector3 fluidLocation)
```
*Samples the fluid distance field to find the nearest fluid location. Unlike **GetNeartestFluidLocation2D** this returns the location of the fluid including the world space height of the fluid. This can be useful for directly positioning objects like an audio source at that location.*

- *fluidLocation The resulting nearest location to worldPos containing fluid.*

##### Example
This script places a GameObject containing a AudioSource at the nearest fluid contained in the Fluid Simulation relative to the object. This could be attached to a camera of player object.
```c#
public class FluidFinder : MonoBehaviour
{
    public GameObject audioSource;

    void Update()
    {
        FluidFrenzy.FluidSimulationManager.GetNeartestFluidLocation3D(transform.position, out Vector3 location);
        audioSource.transform.position = location;
    }
}
```

---

<div style="page-break-after: always;"></div>

<a name="using-shadergraph"></a>
