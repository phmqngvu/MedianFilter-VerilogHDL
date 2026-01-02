import numpy as np
from PIL import Image
from skimage.metrics import peak_signal_noise_ratio, structural_similarity
import matplotlib.pyplot as plt
from matplotlib import rcParams

rcParams['font.family'] = 'Times New Roman'

IMG_REF = "original.bmp"
IMG_OUT = "output.bmp"

# 1. Đọc ảnh grayscale
img_ref = Image.open(IMG_REF).convert("L")
img_out = Image.open(IMG_OUT).convert("L")

ref = np.array(img_ref, dtype=np.uint8)
out = np.array(img_out, dtype=np.uint8)

if ref.shape != out.shape:
    raise ValueError("Hai ảnh KHÔNG cùng kích thước!")

psnr = peak_signal_noise_ratio(ref, out, data_range=255)
ssim = structural_similarity(ref, out, data_range=255)

plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.imshow(ref, cmap="gray")
plt.title("Original Image", fontsize=12)
plt.axis("off")
plt.subplot(1, 2, 2)
plt.imshow(out, cmap="gray")
plt.title("Output Image", fontsize=12)
plt.axis("off")

plt.figtext(
    0.5, 0.03, 
    f"PSNR = {psnr:.2f} dB    |    SSIM = {ssim:.4f}",
    ha="center",
    fontsize=12
)

plt.tight_layout(rect=[0, 0.05, 1, 1]) 
plt.show()

print(f"PSNR : {psnr:.2f} dB")
print(f"SSIM : {ssim:.4f}")