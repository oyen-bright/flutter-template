# {{project_name.titleCase()}} - agent rules

These rules are mandatory for every agent and every change. `make check` enforces most of them;
a task is not done until `make check` passes.

## 1. Project structure

```
lib/
  main.dart, bootstrap.dart
  app/        app.dart, router/ (app_router, app_routes), di/ (injection, register_module)
  core/       config/, error/ (Failure, mapError), network/, result/ (Result, guard), storage/
  shared/ui/  ui.dart (barrel), components/ (App* widgets), theme/, COMPONENTS.md
  features/<feature>/
    data/          models/, sources/, repositories/
    domain/        entities/, repositories/   (optional - see section 3)
    presentation/  cubit/ OR bloc/, pages/, widgets/
test/            mirrors lib/
```

- **Never create a feature by hand.** Use the brick (section 3). Never create new top-level folders.
- One feature = one business capability (transfer, cards, auth). Shared logic goes in `core/`, shared widgets in `shared/ui/`.
- Features may import another feature's `domain/` only - never its `data/` or `presentation/`.
- Max 400 lines per file (warning at 300). Split pages into `presentation/widgets/`.

## 2. State management: Bloc or Cubit - decide before generating

Pick **per feature**, using this checklist. Write the reason in the one-line comment above the class
(the brick leaves a placeholder for it).

### Use a Bloc if ANY of these is true
1. **Concurrency matters**, so the feature needs an event transformer (`bloc_concurrency`):
   - search, filter or typing triggers requests → `restartable()` (+ debounce)
   - submit payment / transfer / OTP / any one-shot mutation → `droppable()` (blocks double-taps)
   - operations must run in order → `sequential()`
2. **Several inputs.** State reacts to streams as well as the user (websocket, push notifications, connectivity, timers, another bloc).
3. **Multi-step flow** with 4+ distinct user actions (auth, KYC, onboarding wizard, checkout).
4. **Audit trail needed.** You must be able to log *which event* changed the state (money movement, security). `AppBlocObserver.onTransition` logs it.

### Otherwise use a Cubit
Fetch-and-display screens, detail pages, toggles, settings, simple forms with a single submit,
filtering done on the device.

**If unsure, choose Cubit.** If a Cubit later needs a transformer or a stream, convert it to a Bloc. Do not work around it.

### Persistence (`--persist true` → HydratedCubit/HydratedBloc)
- Only for **non-sensitive** state that must survive an app restart: theme, onboarding seen, cached lists for offline first paint.
- **Never** hydrate tokens, PINs, balances, card data or personal data. Secrets go in `TokenStorage` (flutter_secure_storage).

### Rules for both
- A bloc/cubit only emits state. Public methods return `void`/`Future<void>`, never data.
- State is a sealed class: `Initial / Loading / Loaded / Failure` (extend with more states as needed, keep it sealed).
- No `try/catch`, no `dio`, no `BuildContext`, no UI imports in a bloc/cubit. Repositories return `Result<T>` and never throw.
- No navigation, toasts or dialogs from a bloc/cubit. Do them in the page with `BlocListener`:
  ```dart
  BlocListener<TransferBloc, TransferState>(
    listenWhen: (_, s) => s is TransferFailure || s is TransferSubmitted,
    listener: (context, state) => switch (state) {
      TransferFailure(:final failure) => AppToast.error(context, failure.message),
      TransferSubmitted() => context.go(AppRoutes.home),
      _ => null,
    },
    child: ...,
  )
  ```
- Provide blocs/cubits with `BlocProvider(create: (_) => getIt<XCubit>())` at the page that owns them. App-wide state (auth, session) is the only exception and is provided in `app.dart`.
- Every bloc/cubit gets a `bloc_test` test (the brick generates it - keep it passing and extend it).

## 3. Adding code - always use the bricks

| Task | Command |
|---|---|
| New feature | `make feature NAME=<snake_name> TYPE=<cubit\|bloc> PERSIST=<true\|false> DOMAIN=<true\|false> ROUTE=<true\|false>` |
| New shared UI component | `make component NAME=<snake_name> BASE=<ShadWidget or none>` |
| After adding/changing `@injectable` classes or assets | `make gen` |
| Before finishing any task | `make check` |

- `DOMAIN=true` (default): entity + repository interface in `domain/`. Use `DOMAIN=false` only for thin features that just display API data and that no other feature depends on.
- `ROUTE=true` adds the path to `AppRoutes` and a `GoRoute` to `app_router.dart` automatically.
- Extending an existing feature (new endpoint): add the method to `data/sources` → `data/repositories` (wrapped in `guard`) → the domain interface → the bloc/cubit. Do not create a second feature for the same capability.

## 4. Data layer

- Data sources own the endpoint paths and Dio calls, and return models. They may throw.
- Repositories wrap every method body in `guard(() async { ... })` and return `Result<T>`. This is the only try/catch in a feature.
- `Failure.message` is shown to users, so it must be human-readable. Never show `e.toString()`.
- Models: `fromJson` / `toJson` + `toEntity()` when a domain layer exists. Entities are plain Equatable classes with no JSON.

## 5. UI - which path to take

- **The user gave a Figma link or design** → use the `figma-to-flutter` skill. It audits existing components *before* creating anything.
- **No design, only instructions** → use the `build-ui` skill: compose shadcn_ui components through the `App*` wrappers, using shadcn's default look.

Rules for both:
- Features import UI only from `package:{{project_name.snakeCase()}}/shared/ui/ui.dart`. **Never import `package:shadcn_ui` in a feature.** If a shadcn widget isn't wrapped yet, run `make component` and wrap it.
- Read `lib/shared/ui/COMPONENTS.md` before building UI. Reuse → extend (named constructor) → create new, in that order.
- No hardcoded colors, text styles, radii or spacing: use `context.colors`, `context.text`, `AppSpacing`, `AppRadius`.
- Loading lists use `AppSkeletonList`/`AppSkeleton`, never a centered spinner. Empty and error states use `AppEmptyView`/`AppErrorView`.
- Icons: `LucideIcons.*` (no design) or exported SVG assets (design). Never `Icons.*`.

## 6. Tests and done criteria

A task is done when:
1. `make check` passes (format, analyze, structure, tests).
2. New blocs/cubits and repositories have tests for success and failure.
3. You report which Bloc/Cubit choice you made and why, in one line.
