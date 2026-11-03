# flutter-template

Mason bricks that create Flutter apps with one fixed, agent-friendly architecture:
feature-first folders, Bloc **or** Cubit chosen per feature, get_it + injectable, go_router, dio,
`Result`-returning repositories, and shadcn_ui behind `App*` wrapper widgets.

| Brick | Used | Generates |
|---|---|---|
| `app` | once per project | the whole skeleton + AGENTS.md / CLAUDE.md + Claude skills + `tool/check_structure.dart` + Makefile |
| `feature` | many times | `lib/features/<name>/{data,domain,presentation}` with a Cubit or Bloc, page, route, tests |
| `ui_component` | many times | `lib/shared/ui/components/app_<name>.dart`, registered in COMPONENTS.md and `ui.dart` |

## Prerequisites

```bash
dart pub global activate mason_cli
```

## New project

```bash
cd ~/Documents/Flutter/Packages/flutter-template
mason get
mason make app -o ~/Documents/Flutter/Projects --project_name my_app --org com.mycompany
cd ~/Documents/Flutter/Projects/my_app
make check
```

The post-gen hook runs `flutter create` (android + ios), `pub get`, `mason get` and code generation.

## Inside a generated project

```bash
make feature NAME=transfer TYPE=bloc            # Bloc vs Cubit rules: AGENTS.md section 2
make feature NAME=cards TYPE=cubit PERSIST=true
make component NAME=otp_field BASE=ShadInputOTP
make check                                      # format + analyze + structure rules + tests
```

## What keeps agents consistent

1. **AGENTS.md** (imported by CLAUDE.md): structure, Bloc/Cubit decision checklist, data and UI rules.
2. **Skills** in `.claude/skills/`: `add-feature`, `build-ui` (no design → shadcn), `figma-to-flutter`
   (design → audit existing components, then reuse / extend / create).
3. **`tool/check_structure.dart`** run by `make check`: fails on wrong folders, shadcn imported in features,
   dio outside data, try/catch in blocs/cubits, hardcoded colors, cross-feature imports, files over 400 lines,
   and components missing from COMPONENTS.md.

## Sharing the template

The generated `mason.yaml` points at `bricks_path` (this folder by default). To share the template, push this repo
and generate with `--bricks_path` set to a checkout path, or change the generated `mason.yaml` entries to
`git: { url: ..., path: bricks/feature }`.
