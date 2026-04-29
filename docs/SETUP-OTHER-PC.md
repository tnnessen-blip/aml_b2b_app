# Work From Another PC

This repo is prepared so you can clone it on another machine and continue in VS Code without hand-editing local paths.

## What you need

1. Git
2. VS Code
3. Flutter stable
4. Chrome for web runs, or Android/Windows tooling if you want native targets

## Clone and open

```powershell
git clone <your-repo-url>
cd aml_b2b_app
code .
```

## First run in VS Code

1. Open the repo root in VS Code.
2. Install the recommended extensions.
3. Run `Flutter doctor`.
4. Run `Flutter pub get`.
5. Run `Flutter analyze`.
6. Run `Flutter run web`, `Flutter run desktop`, or `Flutter test`.
7. Use `Flutter app` in `Run and Debug` for normal debugging.

## Notes

- The whole Flutter app now lives in this repo root.
- `prototype/pwa/` contains the earlier HTML/CSS/JS prototype as design reference.
- Local machine files such as `android/local.properties`, `.dart_tool/`, `build/`, and generated IDE files are ignored in Git.
- VS Code uses `scripts/flutterw.ps1`, which looks for Flutter in `.fvm/flutter_sdk`, `FLUTTER_ROOT`, PATH, or common Windows locations like `C:\Flutter`.
