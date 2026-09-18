---
title: AI Skills
permalink: /docs/ai_skills/
---


Fluid Frenzy includes AI Skills so a coding assistant can set up, preview, and script the simulation using the same menus and public C# APIs described in this documentation. The skills live in the package at `FluidFrenzy/AI/Skills/`. Each skill is a `SKILL.md` file.

They are meant for Unity AI, Cursor, and similar assistants that read project skills. They are not a replacement for this documentation, and they do not invent APIs. If an assistant is unsure whether Fluid Frenzy is in the project, it should start with **fluid-frenzy-setup-and-overview**.

### How to use them

1. Import Fluid Frenzy so `FluidFrenzy/AI/Skills/` is in the project.
2. Point your assistant at those skills, or ask it to follow the Fluid Frenzy skills for the task.
3. Use the table below to pick the skill that matches the job. One focused skill is better than mixing several at once.
4. Check the result in the Scene view. Use [Edit Mode Preview](../simulation_debugger#edit-mode-preview) or Play Mode, then the [Simulation Debugger](../physics_colliders#simulation-debug-editor) if something looks wrong.

| Skill | Use it when |
| :--- | :--- |
| `fluid-frenzy-setup-and-overview` | Installing Fluid Frenzy, checking render pipelines, importing samples, or choosing which skill to use next. |
| `fluid-frenzy-create-simulations` | Adding water, lava, Flow or Flux, or a Water World. |
| `fluid-frenzy-create-terraform-simulation` | Creating [Terraform Terrain](../terrain#terraform-terrain) and dual-fluid terraform (water, lava, and terrain reactions). |
| `fluid-frenzy-add-modifiers-and-obstacles` | Placing persistent sources, flow, forces, vortices, terrain brushes, or procedural obstacles. |
| `fluid-frenzy-buoyancy-and-proximity` | Making objects float, adding Rigidbody buoyancy and wakes, or fading audio by distance to fluid. |
| `fluid-frenzy-script-and-query-fluid` | Custom C# such as adding fluid on click, sampling height, or reading velocity. Not for ordinary floating. |
| `fluid-frenzy-preview-and-debug` | Previewing in Edit Mode, missing surfaces, wrong heights, settings mismatches, or build shader stripping. |

The setup skill routes to the others. Floating, wakes, and shoreline audio belong in **buoyancy-and-proximity**. Custom sampling belongs in **script-and-query-fluid**. Visibility and Preview problems belong in **preview-and-debug**.

---

<div style="page-break-after: always;"></div>

<a name="third-party-support"></a>
