# Local AI Generation Capabilities (This Device)

## Installed / prepared
- IBM Cloud CLI (`ibmcloud`) installed
- Python image-generation stack prepared in `.venv-imagegen`
  - `diffusers`, `transformers`, `accelerate`, `torch`, `pillow`

## Image generation
- Script: `scripts/generate_image_local.py`
- Uses open-source `stabilityai/sd-turbo` baseline on CPU
- Practical for still images and frame generation (speed depends on hardware)

## Video generation
- High-quality 15-20s AI-native video generation fully local on phone-class hardware is generally not practical.
- Recommended approach now:
  1) generate still frames locally
  2) animate/stitch with ffmpeg (`scripts/animate_flowmap.sh` and `docs/plans/FFMPEG-AI-STITCHING-ENGINE.md`)

## Stable Diffusion and video
- Stable Diffusion is primarily image-focused.
- Video variants exist (e.g., Stable Video Diffusion) but are usually heavy for local phone runtime.

## IBM Cloud CLI login note
`ibmcloud login -a https://cloud.ibm.com -u passcode -p <code>` uses a one-time passcode. If rejected, regenerate passcode and retry.
