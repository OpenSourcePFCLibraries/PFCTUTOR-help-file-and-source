<#
.SYNOPSIS
    Builds pfctutor.chm and pfctutor.pdf from the sources in src.

.DESCRIPTION
    1. Copies src to build.
    2. HTML Help Workshop's hhc.exe compiles build\pfctutor.hhp to pfctutor.chm.
    3. Microsoft Edge prints build\pfctutor.htm to pfctutor.pdf.

    Needs HTML Help Workshop (https://learn.microsoft.com/previous-versions/windows/desktop/htmlhelp/microsoft-html-help-downloads)
    and Microsoft Edge.

.PARAMETER NoPdf
    Only builds the CHM.
#>
param([switch]$NoPdf)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$build = Join-Path $root 'build'

if (Test-Path $build) { Remove-Item $build -Recurse -Force }
Copy-Item (Join-Path $root 'src') $build -Recurse

# The CHM.  hhc.exe returns 1 when it succeeds.
$hhc = Join-Path ${env:ProgramFiles(x86)} 'HTML Help Workshop\hhc.exe'
if (-not (Test-Path $hhc)) { throw "HTML Help Workshop isn't installed ($hhc)" }
& $hhc (Join-Path $build 'pfctutor.hhp') | Out-Host
if ($LASTEXITCODE -ne 1) { throw 'hhc.exe failed' }
Copy-Item (Join-Path $build 'pfctutor.chm') (Join-Path $root 'pfctutor.chm') -Force
Write-Host 'pfctutor.chm'

if ($NoPdf) { return }

# The PDF
$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw "Microsoft Edge isn't installed" }
$pdf = Join-Path $root 'pfctutor.pdf'
Remove-Item $pdf -ErrorAction SilentlyContinue
$url = 'file:///' + ((Join-Path $build 'pfctutor.htm') -replace '\\', '/' -replace ' ', '%20')
$edgeArgs = @('--headless', '--disable-gpu', '--no-first-run', "--user-data-dir=`"$(Join-Path $build 'edge')`"",
    '--no-pdf-header-footer', '--generate-pdf-document-outline', "--print-to-pdf=`"$pdf`"", "`"$url`"")
Start-Process $edge -ArgumentList $edgeArgs -Wait -WindowStyle Hidden
if (-not (Test-Path $pdf)) { throw 'Edge did not print the PDF' }
Write-Host 'pfctutor.pdf'
