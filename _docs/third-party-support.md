---
title: Third-party Support
permalink: /docs/third_party_support/
---

### Table of contents
{:.no_toc}
* this unordered seed list will be replaced by toc as unordered list
{:toc}
---

Fluid Frenzy has support for third-party assets, if you make use of a asset and would like it to work with with Fluid Frenzy submit a feature request and we will investigate integration options.
If you are a Unity Asset Store publisher and wish for Fluid Frenzy to support your asset feel free to contact me!.
Currently Fluid Frenzy supports the following assets:

### Enviro 3 Sky and Weather

Fluid Frenzy has support for [Enviro 3 Sky and Weather](https://assetstore.unity.com/packages/tools/particles-effects/enviro-3-sky-and-weather-236601). 
Support is directly integrated in the Water and Lava shader and will automatically be enabled when the Enviro 3 package is installed in your project.
If it does not work automatically by default you may have to run the following command: *Edit > Fluid Frenzy > Generate External Shader Compatibility*. 

If the asset does not exist in the default location it is installedt to by default Fluid Frenzy will attempt to find the asset and automatically patch the shader headers. See *ExternalCompatibilityGenerate.cs* for more information is this does not work as expected.

### Curved World
Fluid Frenzy has support for [Curved World](https://assetstore.unity.com/packages/vfx/shaders/curved-world-173251).
Support is directly integrated in the water and lava shader the same way as any of the shaders included in the Curved World asset.
If it does not work automatically by default you may have to run the following command: *Edit > Fluid Frenzy > Generate External Shader Compatibility*. 

![alt text](../../assets/images/thirdparty_enviro3.png)

---

<div style="page-break-after: always;"></div>

<a name="future-updates-roadmap"></a>
