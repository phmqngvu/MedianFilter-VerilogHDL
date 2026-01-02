import numpy as np

# ================== CẤU HÌNH ==================
WIDTH  = 430
HEIGHT = 554

INPUT_FILE  = "input.hex"
OUTPUT_FILE = "output.hex"


# ================== HÀM HỖ TRỢ ==================

# Đọc file hex giống $readmemh
def load_hex_image(filepath):
    with open(filepath, 'r') as f:
        content = f.read().split()
        return [int(x, 16) if x.lower() != "xx" else 0xff for x in content]


# Sort 3 phần tử → (min, mid, max)
def sort3(a, b, c):
    arr = [a, b, c]
    arr.sort()
    return arr[0], arr[1], arr[2]


# Median cho kernel 1x3 hoặc 3x1
def median_1d(a, b, c):
    return sorted([a, b, c])[1]


# ================== MEDIAN 3x3 (Giống RTL) ==================

def calculate_median_pixel(p1, p2, p3,
                           p4, p5, p6,
                           p7, p8, p9):

    # ---- Stage 1: sort từng hàng ----
    r1_min, r1_mid, r1_max = sort3(p1, p2, p3)
    r2_min, r2_mid, r2_max = sort3(p4, p5, p6)
    r3_min, r3_mid, r3_max = sort3(p7, p8, p9)

    # ---- Stage 2: chọn 3 ứng viên ----
    _, cand1, _ = sort3(r1_mid, r2_mid, r3_mid)  # mid of mid
    cand2 = max(r1_min, r2_min, r3_min)          # max of min
    cand3 = min(r1_max, r2_max, r3_max)          # min of max

    # ---- Stage 3: median cuối ----
    _, median_out, _ = sort3(cand1, cand2, cand3)

    return median_out


# ================== MAIN ==================

def main():
    print(">>> Loading input image...")
    img_mem = load_hex_image(INPUT_FILE)

    if len(img_mem) != WIDTH * HEIGHT:
        raise ValueError(
            f"Sai kích thước ảnh: {len(img_mem)} != {WIDTH*HEIGHT}"
        )

    output_data = []

    print(">>> Running median filter with border handling...")

    for y in range(HEIGHT):
        for x in range(WIDTH):
            idx = y * WIDTH + x

            # -------- GÓC ẢNH --------
            if (x == 0 and y == 0) or \
               (x == WIDTH-1 and y == 0) or \
               (x == 0 and y == HEIGHT-1) or \
               (x == WIDTH-1 and y == HEIGHT-1):
                pixel_out = img_mem[idx]

            # -------- VIỀN TRÊN / DƯỚI (1x3) --------
            elif y == 0 or y == HEIGHT - 1:
                pixel_out = median_1d(
                    img_mem[y * WIDTH + (x - 1)],
                    img_mem[y * WIDTH + x],
                    img_mem[y * WIDTH + (x + 1)]
                )

            # -------- VIỀN TRÁI / PHẢI (3x1) --------
            elif x == 0 or x == WIDTH - 1:
                pixel_out = median_1d(
                    img_mem[(y - 1) * WIDTH + x],
                    img_mem[y * WIDTH + x],
                    img_mem[(y + 1) * WIDTH + x]
                )

            # -------- PIXEL BÊN TRONG (3x3) --------
            else:
                pixel_out = calculate_median_pixel(
                    img_mem[(y-1)*WIDTH + (x-1)],
                    img_mem[(y-1)*WIDTH + (x  )],
                    img_mem[(y-1)*WIDTH + (x+1)],
                    img_mem[(y  )*WIDTH + (x-1)],
                    img_mem[(y  )*WIDTH + (x  )],
                    img_mem[(y  )*WIDTH + (x+1)],
                    img_mem[(y+1)*WIDTH + (x-1)],
                    img_mem[(y+1)*WIDTH + (x  )],
                    img_mem[(y+1)*WIDTH + (x+1)]
                )

            output_data.append(pixel_out)

    print(">>> Writing output file...")
    with open(OUTPUT_FILE, "w") as f:
        for val in output_data:
            f.write(f"{val:02x}\n")

    print(">>> DONE! Output saved as:", OUTPUT_FILE)


if __name__ == "__main__":
    main()
