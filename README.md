# Video -> GIF (Python + FFmpeg)

This repo contains a minimal Python CLI wrapper around FFmpeg's recommended high-quality GIF workflow (`palettegen` + `paletteuse`).

## Prerequisites

- Python 3.9+
- FFmpeg installed and available as `ffmpeg` in your `PATH`, or pass `--ffmpeg` / set `FFMPEG_PATH`.

### Install FFmpeg (Windows)

1. Download a Windows build of FFmpeg.
2. Ensure `ffmpeg.exe` is on your `PATH`, or use `--ffmpeg C:\path\to\ffmpeg.exe`.

Or install a local copy into this repo (auto-detected):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install_ffmpeg_windows.ps1
```

## Usage

Install in editable mode:

```powershell
python -m pip install -e .
```

Then:

```powershell
python -m video_to_gif --help
python -m video_to_gif input.mp4 output.gif --fps 12 --width 640 --start 5 --duration 3
```

If you install it as a package, you can use:

```powershell
video-to-gif input.mp4 output.gif --fps 12 --width 640
```

## Web UI (Frontend/Backend Split)

- Frontend: Django (default `http://127.0.0.1:8010/`)
- Backend: FastAPI API (default `http://127.0.0.1:8011/healthz`)

Install everything (Windows):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup_windows.ps1
```

Run Web UI:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_webui.ps1
```

Open `http://127.0.0.1:8010/`.

Run separately (two terminals):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_backend.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run_frontend.ps1 -ApiUrl http://127.0.0.1:8011
```

One-click startup (setup + run):

```powershell
powershell -ExecutionPolicy Bypass -File .\start_webui.ps1
```

If you prefer double-click on Windows Explorer:

- `start_webui.cmd`

## Notes

- `--loop 0` means infinite loop (GIF default).
- For best quality, keep `--dither sierra2_4a` and tune `--fps`, `--width`, `--duration`.
