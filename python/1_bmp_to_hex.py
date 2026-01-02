from PIL import Image
import numpy as np

img = Image.open("input.bmp").convert("L")

pixels = np.array(img, dtype=np.uint8)

height, width = pixels.shape
print(f"Image size: {width} x {height}")

pixels_flat = pixels.flatten()

with open("input.hex", "w") as f:
    for p in pixels_flat:
        f.write(f"{p:02X}\n")

print("Done! File input.hex has been created.")