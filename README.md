# AML Kontrollrom

Cross-platform Flutter app for AML / hvitvasking case triage across web, desktop and mobile.

## Open in VS Code

1. Open this folder, `aml_b2b_app`, as the workspace root in VS Code.
2. Install the recommended extensions.
3. Run `Tasks: Run Task`.
4. Run `Flutter pub get`.
5. Start the app with `Flutter run web`, `Flutter run desktop`, or `Run and Debug`.

## Common workflow

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

For desktop:

```powershell
flutter run -d windows
```

## What lives here

- `lib/app/` app entry and theme wiring
- `lib/features/dashboard/` screens, state and widgets for the AML workspace
- `lib/models/` shared domain models
- `lib/data/` local demo data
- `lib/theme/` shared color tokens
- `test/` widget tests
- `docs/` setup notes and roadmap
- `scripts/flutterw.ps1` Flutter wrapper used by VS Code tasks
- `prototype/pwa/` the earlier HTML/CSS/JS prototype kept as design reference
- `.github/workflows/flutter-ci.yml` CI for analyze, test and web build

## Work from another PC

See [docs/SETUP-OTHER-PC.md](docs/SETUP-OTHER-PC.md).

## Norway AML direction

The current product direction for Norwegian AML automation is documented in
[docs/NORWAY_AML_AUTOMATION.md](docs/NORWAY_AML_AUTOMATION.md).

## Notes

- The VS Code tasks resolve Flutter from `FLUTTER_ROOT`, PATH, `.fvm/flutter_sdk`, or common install locations such as `C:\Flutter`.
- Machine-specific files such as `.dart_tool/`, `build/`, `android/local.properties`, and generated platform files are ignored in Git.

## Flutter docs

- [Install Flutter with VS Code](https://docs.flutter.dev/install/with-vs-code)
- [Flutter desktop setup](https://docs.flutter.dev/platform-integration/desktop)
