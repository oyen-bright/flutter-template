---
name: figma-to-flutter
description: >-
  Implements a Figma design (URL, node id, or exported frame) in this Flutter app. Use whenever the user
  shares a Figma link or asks to build a screen or component "from the design". Audits the existing shared
  components FIRST and decides, element by element, whether to reuse, extend or create a component, so the
  design never turns into a pile of one-off widgets. For UI with no design, use the build-ui skill instead.
metadata:
  argument-hint: "[figma-url-or-node-id]"
---

# Figma to Flutter (component-first)

The goal is **pixel-accurate screens built from as few, as reusable components as possible**.
The worst outcome is a new widget for every rectangle in the design. Always follow the phases in
order and never skip phase 2.

## Phase 1 - Read the design

1. If no Figma URL or node id was given, ask for one. Do not work from a description of a design.
2. Load the frame through the Figma MCP (`get_design_context`; load the `figma:figma-design-to-code`
   skill first if it is available). Use node properties, not a screenshot: layout mode, padding, gaps,
   fills, strokes, radii, typography, component names/variants, and Figma variables.
3. Break the frame into a **design inventory**, a flat list of UI elements, e.g.
   `primary CTA`, `amount input`, `OTP field`, `beneficiary row`, `section header`, `bottom sheet`.
   Note when Figma marks something as a component instance (same component name = same Flutter widget).
4. Collect the design tokens used: colors, text styles, radii, spacing.

## Phase 2 - Audit existing UI before writing anything

Read, in this order:
1. `lib/shared/ui/COMPONENTS.md`: the registry of shared components and their variants.
2. `lib/shared/ui/theme/app_theme.dart` and `app_tokens.dart`: existing tokens.
3. Search for similar feature-local widgets: `grep -rl "class " lib/features/*/presentation/widgets`.

Then classify **every** inventory item with exactly one decision:

| Decision | When | Action |
|---|---|---|
| **REUSE** | An existing component matches with its current params (same structure, differences are only values it already accepts: text, icon, color token) | Use it. No new code. |
| **EXTEND** | Same structure and behavior, but a new look (new fill/border/size) or 1-2 missing optional params | Add a **named constructor** (e.g. `AppButton.pill`) or an optional nullable param with a fallback to the current default. Never a boolean like `isFigmaStyle`. Never break existing call sites. |
| **NEW SHARED** | Not similar to anything AND it appears 2+ times in this design or obviously will elsewhere (rows, cards, chips, inputs, sheets) | `make component NAME=<name> BASE=<ShadWidget or none>`, then implement it. Base it on a shadcn widget when one fits. |
| **FEATURE-LOCAL** | Used on exactly one screen and specific to that feature (a hero illustration block, a one-off summary layout) | Widget in `lib/features/<feature>/presentation/widgets/`, composed from shared components. |
| **PROMOTE** | A feature-local widget in another feature already matches | Move it to `shared/ui/components` via `make component`, update both features, register it. |

Decision rules:
- Prefer, in order: REUSE > EXTEND > NEW SHARED > FEATURE-LOCAL. Choose a later option only if you can say why the earlier one fails.
- Two items that differ only in values (text, icon, color, an optional trailing widget) are **one** component.
- EXTEND is wrong if it needs more than ~3 new params or changes the layout structure. Then it is NEW SHARED.
- Design tokens: a Figma color or text style matching an existing token maps to that token. Otherwise:
  - brand colors shadcn has a slot for (primary, background, border, ...) → override them in `AppTheme` (light and dark);
  - other colors → add to the `custom` map in `AppTheme` (light and dark) plus a typed getter in `AppCustomColors`, named after the role (`success`, not `green2`);
  - text styles → set `textTheme` in `AppTheme` (font family, h1-h4, p, small, muted); spacing/radius → `app_tokens.dart`.
  Use them through `context.colors` / `context.text` / `AppSpacing` / `AppRadius`. Never inline hex values or `TextStyle(fontSize: ...)` in features.

## Phase 3 - Present the plan and wait for confirmation

Show the user a table before writing code:

```
| Design element      | Decision      | Component                         | Notes                         |
|---------------------|---------------|-----------------------------------|-------------------------------|
| Primary CTA         | REUSE         | AppButton(expand: true)           |                               |
| Outline pill button | EXTEND        | AppButton.pill (new ctor)         | radius pill, 44 high          |
| Beneficiary row     | NEW SHARED    | AppListRow (base: none)           | used 3x here, likely in cards |
| Balance hero card   | FEATURE-LOCAL | wallet/presentation/widgets/...   | only on wallet home           |
| Color #12B76A       | NEW TOKEN     | context.colors.success (custom)   | no existing match             |
```

Also list: assets to export, new tokens, new routes, and whether a new feature is needed
(if so, decide Bloc vs Cubit with AGENTS.md section 2 and use `make feature`).
**Wait for the user to confirm or adjust.**

## Phase 4 - Implement

1. Tokens first (theme/tokens), then EXTEND changes, then NEW SHARED components, then feature widgets, then the page.
2. Every new or extended shared component: update its row in `lib/shared/ui/COMPONENTS.md` (variants and key params).
   `make component` adds the row; you fill in "Use for" and "Variants".
3. Assets: export icons as SVG to `assets/svg/ic_<name>.svg` and images as PNG @2x/@3x to `assets/png/img_<name>.png`
   from Figma. Never substitute `Icons.*` or Lucide for a custom Figma icon. Then run `make gen` and use `Assets.*`.
4. Copy text exactly as in Figma (casing and punctuation). Don't invent labels, helper text or states that aren't in the design.
   If a state (error, empty, loading) is missing from the design, use `AppErrorView`/`AppEmptyView`/`AppSkeleton` and say so.
5. Pages stay layout-only: `AppScaffold` + composed components, state from the bloc/cubit via `BlocBuilder`/`BlocListener`.
6. Never import `package:shadcn_ui` in a feature. Go through `shared/ui/ui.dart`.

## Phase 5 - Verify and report

- `make check` must pass.
- Report: the final decision table (with any changes from the plan), files changed, new components/tokens, and anything in the design you could not match exactly.
