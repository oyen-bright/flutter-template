# {{project_name.titleCase()}}

{{{description}}}

## Setup

```bash
make setup     # pub get, mason get, code generation
make run       # flutter run with env/dev.json
```

## Everyday commands

```bash
make feature NAME=transfer TYPE=bloc     # new feature (see AGENTS.md section 2 for bloc vs cubit)
make component NAME=otp_field BASE=ShadInputOTP
make gen                                  # after changing @injectable classes or assets
make check                                # format + analyze + structure rules + tests
```

Architecture and rules: [AGENTS.md](AGENTS.md).
