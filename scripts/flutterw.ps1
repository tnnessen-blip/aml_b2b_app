param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$FlutterArgs
)

$ErrorActionPreference = "Stop"

function Get-FlutterCommand {
  $candidates = @()

  $localFvmRoot = Join-Path (Get-Location) ".fvm\\flutter_sdk"
  $candidates += (Join-Path $localFvmRoot "bin/flutter.bat")
  $candidates += (Join-Path $localFvmRoot "bin/flutter")

  if ($env:FLUTTER_ROOT) {
    $candidates += (Join-Path $env:FLUTTER_ROOT "bin/flutter.bat")
    $candidates += (Join-Path $env:FLUTTER_ROOT "bin/flutter")
  }

  $candidates += @(
    "C:\\Flutter\\bin\\flutter.bat",
    "C:\\src\\flutter\\bin\\flutter.bat",
    (Join-Path $HOME "flutter\\bin\\flutter.bat"),
    (Join-Path $HOME "development\\flutter\\bin\\flutter.bat")
  )

  foreach ($candidate in $candidates) {
    if ($candidate -and (Test-Path -LiteralPath $candidate)) {
      return $candidate
    }
  }

  $command = Get-Command flutter -ErrorAction SilentlyContinue
  if ($command) {
    return $command.Source
  }

  return $null
}

$flutter = Get-FlutterCommand
if (-not $flutter) {
  Write-Error "Flutter SDK was not found. Install Flutter or set FLUTTER_ROOT before running this task."
}

& $flutter @FlutterArgs
exit $LASTEXITCODE
