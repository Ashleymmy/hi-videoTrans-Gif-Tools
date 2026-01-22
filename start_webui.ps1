param(
  [string]$BindHost = "127.0.0.1",
  [int]$Port = 8010,
  [int]$BackendPort = 8011,
  [string]$VenvPath = ".venv",
  [switch]$PauseOnError
)

$ErrorActionPreference = "Stop"

try {
  $repoRoot = $PSScriptRoot
  $setup = Join-Path $repoRoot "scripts\\setup_windows.ps1"
  $run = Join-Path $repoRoot "scripts\\run_webui.ps1"

  if (-not [System.IO.Path]::IsPathRooted($VenvPath)) {
    $VenvPath = Join-Path $repoRoot $VenvPath
  }

  function Test-PortAvailable([string]$HostAddress, [int]$P) {
    try {
      $ip = [System.Net.IPAddress]::Parse($HostAddress)
      $listener = [System.Net.Sockets.TcpListener]::new($ip, $P)
      $listener.Start()
      $listener.Stop()
      return $true
    } catch {
      return $false
    }
  }

  if (-not (Test-PortAvailable -HostAddress $BindHost -P $Port)) {
    $base = $Port
    for ($i = 1; $i -le 20; $i++) {
      $candidate = $base + $i
      if (Test-PortAvailable -HostAddress $BindHost -P $candidate) {
        $Port = $candidate
        break
      }
    }
  }

  if (($BackendPort -eq $Port) -or (-not (Test-PortAvailable -HostAddress $BindHost -P $BackendPort))) {
    $repoBase = $BackendPort
    for ($i = 0; $i -le 20; $i++) {
      $candidate = $repoBase + $i
      if ($candidate -eq $Port) { continue }
      if (Test-PortAvailable -HostAddress $BindHost -P $candidate) {
        $BackendPort = $candidate
        break
      }
    }
  }

  if (-not (Test-Path -LiteralPath (Join-Path $VenvPath "Scripts\\python.exe"))) {
    & $setup -VenvPath $VenvPath
  }

  Set-Location $repoRoot
  Write-Host ("Web UI: http://$BindHost`:$Port/ (API: http://$BindHost`:$BackendPort/)") -ForegroundColor Cyan
  & $run -VenvPath $VenvPath -BindHost $BindHost -Port $Port -BackendPort $BackendPort
} catch {
  Write-Host ""
  Write-Host "Failed to start Web UI:" -ForegroundColor Red
  Write-Host $_.Exception.Message -ForegroundColor Red
  if ($PauseOnError) {
    Write-Host ""
    Read-Host "Press Enter to close"
  }
  exit 1
}
