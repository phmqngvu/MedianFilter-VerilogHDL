import numpy as np
from PIL import Image

WIDTH  = 430
HEIGHT = 554
HEX_FILE = "verilog.hex"
BMP_FILE = "output.bmp"

pixels = []

with open(HEX_FILE, "r") as f:
    for line_num, line in enumerate(f, start=1):
        line = line.strip()

        if line == "":
            continue

        # Nếu là xx / XX thì thay bằng FF
        if line.lower() == "xx":
            value = 0xFF
        else:
            try:
                value = int(line, 16)
            except ValueError:
                raise ValueError(f"Lỗi dòng {line_num}: '{line}' không phải hex hợp lệ")

        pixels.append(value)

pixels = np.array(pixels, dtype=np.uint8)

if pixels.size != WIDTH * HEIGHT:
    raise ValueError(
        f"Sai kích thước: đọc được {pixels.size} pixel, "
        f"nhưng WIDTH*HEIGHT = {WIDTH * HEIGHT}"
    )

image_array = pixels.reshape((HEIGHT, WIDTH))

img = Image.fromarray(image_array, mode="L")
img.save(BMP_FILE)

print(f"Done! Image saved as {BMP_FILE}")
