param(
    [string]$LyXPath = "C:\Program Files\LyX 2.5\bin\LyX.exe"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildDir = Join-Path $repoRoot "build"
$lyxSource = Join-Path $repoRoot "phdthesis.lyx"
$texSource = Join-Path $buildDir "phdthesis.tex"

if (-not (Test-Path -LiteralPath $LyXPath)) {
    throw "LyX executable not found: $LyXPath"
}

if (Test-Path -LiteralPath $buildDir) {
    $resolvedBuildDir = (Resolve-Path -LiteralPath $buildDir).Path
    $expectedBuildDir = Join-Path $repoRoot "build"
    if ($resolvedBuildDir -ne $expectedBuildDir) {
        throw "Refusing to clean an unexpected build directory: $resolvedBuildDir"
    }
    Remove-Item -LiteralPath $resolvedBuildDir -Recurse -Force
}
New-Item -ItemType Directory -Path $buildDir | Out-Null

$lyxProcess = Start-Process -FilePath $LyXPath `
    -ArgumentList @("-n", "-f", "all", "-E", "pdflatex", $texSource, $lyxSource) `
    -Wait -PassThru
if ($lyxProcess.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $texSource)) {
    throw "LyX export failed."
}

Push-Location $repoRoot
try {
    & pdflatex -draftmode -interaction=nonstopmode -file-line-error `
        -output-directory=build build/phdthesis.tex
    if ($LASTEXITCODE -ne 0) { throw "Initial pdflatex pass failed." }

    & biber --input-directory=build --output-directory=build phdthesis
    if ($LASTEXITCODE -ne 0) { throw "Biber failed." }

    & pdflatex -draftmode -interaction=nonstopmode -file-line-error `
        -output-directory=build build/phdthesis.tex
    if ($LASTEXITCODE -ne 0) { throw "Reference-resolution pass failed." }

    & pdflatex -interaction=nonstopmode -file-line-error `
        -output-directory=build build/phdthesis.tex
    if ($LASTEXITCODE -ne 0) { throw "Final PDF pass failed." }
}
finally {
    Pop-Location
}

$logPath = Join-Path $buildDir "phdthesis.log"
$fatalPatterns = @(
    "Citation .* undefined",
    "Reference .* undefined",
    "There were undefined",
    "LaTeX Error",
    "Package .* Error",
    "^!"
)
$problems = Select-String -Path $logPath -Pattern $fatalPatterns
if ($problems) {
    $problems | ForEach-Object { Write-Error $_.Line }
    throw "The PDF was produced with unresolved references or LaTeX errors."
}

Write-Host "Successful build: $buildDir\phdthesis.pdf"
