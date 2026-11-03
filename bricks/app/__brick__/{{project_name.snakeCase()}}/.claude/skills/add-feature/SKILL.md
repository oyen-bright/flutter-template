---
name: add-feature
description: >-
  Creates a new feature (or a new endpoint in an existing feature) following this project's architecture:
  decides Bloc vs Cubit, generates the feature with the mason brick, then fills in models, data source,
  repository, state and tests. Use for "add X feature", "integrate the Y API", "create the Z screen and its logic".
---

# Add a feature

## 1. Does a feature already own this?

`ls lib/features`. If an existing feature owns this capability, **extend it** (section 5) instead of creating a new one.

## 2. Decide the flags (AGENTS.md section 2)

Go through the checklist and write down the answers:
- **TYPE**: `bloc` if the feature needs concurrency control (search → restartable, submit/payment → droppable),
  reacts to streams, is a multi-step flow with 4+ user actions, or needs an audit trail. Otherwise `cubit`.
- **PERSIST**: `true` only for non-sensitive state that must survive a restart. Never for tokens, balances or personal data.
- **DOMAIN**: `true` unless it's a thin read-only feature that no other feature uses.
- **ROUTE**: `true` if it has its own screen.

Tell the user your choice in one line, e.g. `transfer: Bloc (droppable submit, multi-step), not persisted, with domain`.

## 3. Generate

```bash
make feature NAME=<snake_name> TYPE=<cubit|bloc> PERSIST=<bool> DOMAIN=<bool> ROUTE=<bool>
```

This creates every file and test, registers the route, and runs codegen. Never create these files by hand.

## 4. Fill in the generated files (in this order)

1. `domain/entities/` + `data/models/`: replace the placeholder `id`/`name` fields with the real ones. The model has `fromJson`/`toJson`/`toEntity`.
2. `data/sources/<name>_remote_data_source.dart`: real endpoint paths and Dio calls. Return models.
3. `domain/repositories/` (interface) + `data/repositories/` (impl): one method per use case, each body wrapped in `guard`.
4. `presentation/<cubit|bloc>/`:
   - Replace the `// <Type>: <reason>` comment with your reason from step 2.
   - States: keep the sealed hierarchy. Add states for each meaningful outcome (e.g. `TransferSubmitted`).
   - Bloc: one event per user intent, each with the right transformer (`droppable()` for submits, `restartable()` for search/load).
5. `presentation/pages/` + `widgets/`: build the UI with the `build-ui` skill (no design) or `figma-to-flutter` (with design).
6. Tests in `test/features/<name>/`: success and failure for every bloc/cubit method and every repository method.

## 5. Extending an existing feature

Add in this order: data source method → repository interface + impl (`guard`) → bloc event/handler or cubit method
→ state(s) → UI → tests. Run `make gen` if you added `@injectable` classes.

## 6. Finish

`make check` must pass. Report: the Bloc/Cubit decision and why, files created or changed, and test results.
