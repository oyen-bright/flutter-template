.PHONY: setup gen watch feature component check format analyze structure test run

# Defaults for `make feature`
TYPE ?= cubit
PERSIST ?= false
DOMAIN ?= true
ROUTE ?= true

setup:            ## First run after cloning
	flutter pub get
	mason get
	$(MAKE) gen

gen:              ## Regenerate DI (injectable) and assets (flutter_gen)
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

feature:          ## make feature NAME=transfer TYPE=bloc PERSIST=false DOMAIN=true ROUTE=true
	@test -n "$(NAME)" || (echo "NAME is required" && exit 1)
	mason make feature --name $(NAME) --type $(TYPE) --persist $(PERSIST) --domain $(DOMAIN) --route $(ROUTE) --on-conflict skip
	$(MAKE) gen

component:        ## make component NAME=otp_field BASE=ShadInputOTP
	@test -n "$(NAME)" || (echo "NAME is required" && exit 1)
	mason make ui_component --name $(NAME) --base "$(or $(BASE),none)" --on-conflict skip

format:
	dart format lib test tool

analyze:
	flutter analyze

structure:
	dart run tool/check_structure.dart

test:
	flutter test

check:            ## Run before every commit / end of every agent task
	dart format --set-exit-if-changed lib test tool
	flutter analyze
	dart run tool/check_structure.dart
	flutter test

run:
	flutter run --dart-define-from-file=env/dev.json
