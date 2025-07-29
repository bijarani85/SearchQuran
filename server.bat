@echo off
setlocal
set PORT=8000
echo Starting tiny web server at http://localhost:%PORT%
powershell -NoProfile -Command ^
  "Add-Type -AssemblyName System.Web; " ^
  "$listener = New-Object System.Net.HttpListener; " ^
  "$prefix = 'http://*:%PORT%/'; " ^
  "$listener.Prefixes.Add($prefix); " ^
  "$listener.Start(); Write-Host 'Listening on' $prefix; " ^
  "while ($true) { $context = $listener.GetContext(); " ^
  "  $req = $context.Request; $path = $req.Url.LocalPath.TrimStart('/'); " ^
  "  if ([string]::IsNullOrEmpty($path)) { $path = 'index.html'; } " ^
  "  $file = Join-Path (Get-Location) $path; " ^
  "  if (Test-Path $file) { " ^
  "    $bytes = [System.IO.File]::ReadAllBytes($file); " ^
  "    $context.Response.ContentType = 'text/html; charset=UTF-8'; " ^
  "    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length); " ^
  "  } else { " ^
  "    $context.Response.StatusCode = 404; " ^
  "    $msg = 'Not Found'; " ^
  "    $buffer = [System.Text.Encoding]::UTF8.GetBytes($msg); " ^
  "    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length); " ^
  "  } " ^
  "  $context.Response.Close(); }"
pause
