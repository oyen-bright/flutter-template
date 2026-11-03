---
name: build-ui
description: >-
  Builds screens and UI from written instructions when there is NO Figma design. Uses shadcn_ui components
  (through the App* wrappers in lib/shared/ui) with shadcn's default look, so screens are consistent without a
  designer. Use for "add a settings screen", "make a form for X", "show a list of Y". If the user provides a
  Figma link or design, use the figma-to-flutter skill instead.
---

# Build UI without a design (shadcn_ui)

With no design, consistency comes from **shadcn's design language plus our wrappers**. Do not invent a
visual style: no custom colors, gradients, shadows or font sizes.

## Steps

1. **Understand the screen.** List what it must show and do. Ask only if behavior is ambiguous; don't ask about visuals.
2. **Check the registry.** Read `lib/shared/ui/COMPONENTS.md`. Map each need to a component:
   - action → `AppButton` (one primary per screen, others `.outline`/`.ghost`; destructive actions use `.destructive`)
   - input → `AppTextField` inside a `ShadForm` (exported from `ui.dart`)
   - grouped content / list row → `AppCard`
   - loading → `AppSkeletonList`/`AppSkeleton`; empty → `AppEmptyView`; error → `AppErrorView`
   - feedback → `AppToast` from a `BlocListener`
3. **Need a shadcn widget that isn't wrapped yet?** (select, switch, checkbox, tabs, dialog, sheet, OTP, date picker,
   badge, avatar, accordion, ...). The list is at the bottom of `COMPONENTS.md`.
   - Run `make component NAME=<name> BASE=<ShadWidget>`, e.g. `make component NAME=select BASE=ShadSelect`.
   - Implement the wrapper in `lib/shared/ui/components/app_<name>.dart`. Expose only the params screens need,
     with shadcn defaults. Check the shadcn_ui source in the pub cache for its real constructor.
   - Fill in its row in `COMPONENTS.md`.
4. **Compose the page** in `lib/features/<feature>/presentation/pages/`:
   - Root is `AppScaffold`. Primary CTA goes in `bottomBar` when it is the main action of the screen.
   - Vertical rhythm with `Gap(AppSpacing.*)`: `lg` between groups, `sm` inside a group, `xl` before section titles.
   - Typography only from `context.text`: `h2`/`h3` titles, `large` section headers, `p` body, `muted` secondary, `small` captions.
   - Colors only from `context.colors`: `primary`, `muted`, `mutedForeground`, `destructive`, `border`, ...
   - Icons from `LucideIcons.*`.
   - Sections over ~80 lines go into `presentation/widgets/`.
5. **Wire state** from the feature's bloc/cubit (`BlocBuilder` for content, `BlocListener` for toasts and navigation).
   If the feature doesn't exist yet, use the `add-feature` skill first.
6. **Verify:** `make check` passes. Report what you built and any new components you added.

## Do not
- Import `package:shadcn_ui` in a feature, or use raw Material widgets (`ElevatedButton`, `TextField`, `Card`) where a wrapper exists.
- Hardcode colors, sizes or text styles.
- Create a new component when an existing one plus a named constructor would do.
