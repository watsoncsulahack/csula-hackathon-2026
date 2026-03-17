from diffusers import StableDiffusionPipeline
import torch
from pathlib import Path

prompt = "8-bit style emergency routing command center, pixel art, top-down map, bright neon HUD"
out = Path("media/frames/serp-flow")
out.mkdir(parents=True, exist_ok=True)

model_id = "stabilityai/sd-turbo"
pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float32)
pipe = pipe.to("cpu")
img = pipe(prompt=prompt, num_inference_steps=1, guidance_scale=0.0).images[0]
img.save(out / "frame_0001.png")
print("saved", out / "frame_0001.png")
