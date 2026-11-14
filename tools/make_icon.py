"""走りとも！配布用アプリアイコン（1024px）を作るスクリプト。
Pillow でフラットデザインのステアリングホイールを描く。生成物:
  - app/assets/icon/app_icon.png      （flutter_launcher_icons のソース）
"""
from PIL import Image, ImageDraw

SIZE = 1024
BG = (232, 236, 242)        # ライトグレー（シリーズ共通の落ち着いた背景色）
RIM = (46, 58, 74)          # ホイールの縁（ダークネイビー）
SPOKE = (70, 86, 105)       # スポーク
HUB = (245, 158, 11)        # ハブ（オレンジ。走りのアクセント）
GRIP = (30, 38, 50)         # グリップの溝


def rounded(im: Image.Image, radius: int) -> Image.Image:
    mask = Image.new("L", im.size, 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle([0, 0, SIZE - 1, SIZE - 1], radius=radius, fill=255)
    out = Image.new("RGBA", im.size, (0, 0, 0, 0))
    out.paste(im, (0, 0), mask)
    return out


def draw_wheel():
    im = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)

    # 背景（角丸ライトグレー）
    d.rounded_rectangle([0, 0, SIZE - 1, SIZE - 1], radius=192, fill=BG + (255,))

    cx, cy = SIZE // 2, SIZE // 2
    rim_r = 360          # 外径
    inner_r = 300        # リム内径
    hub_r = 105          # 中央ハブ

    # リング（外周 = ホイール本体）
    d.ellipse([cx - rim_r, cy - rim_r, cx + rim_r, cy + rim_r], fill=RIM + (255,))
    d.ellipse([cx - inner_r, cy - inner_r, cx + inner_r, cy + inner_r], fill=BG + (255,))

    # グリップの小さな溝（左右に楕円を重ねる）
    for sx in (-1, 1):
        gx = cx + sx * 332
        d.ellipse([gx - 14, cy - 70, gx + 14, cy + 70], fill=GRIP + (255,))

    # スポーク3本（左・右・下）。ハブからリムへ結ぶ太めの帯
    def spoke(x0, y0, x1, y1, width):
        d.line([(x0, y0), (x1, y1)], fill=SPOKE + (255,), width=width)

    spoke(cx - hub_r - 10, cy - 20, cx - inner_r + 10, cy - 10, 96)
    spoke(cx + hub_r + 10, cy - 20, cx + inner_r - 10, cy - 10, 96)
    spoke(cx, cy + hub_r + 10, cx, cy + inner_r - 10, 96)

    # 中央ハブ（オレンジ）
    d.ellipse([cx - hub_r, cy - hub_r, cx + hub_r, cy + hub_r], fill=HUB + (255,))
    d.ellipse([cx - 36, cy - 36, cx + 36, cy + 36], fill=BG + (255,))

    # スピードの揺らし（右上に光条3本）
    star_c = (800, 220)
    d.line([(star_c[0] - 70, star_c[1] + 46), (star_c[0] - 20, star_c[1] - 6)], fill=HUB + (255,), width=16)
    d.line([(star_c[0] + 6, star_c[1] + 60), (star_c[0] + 42, star_c[1] - 26)], fill=HUB + (255,), width=16)
    d.line([(star_c[0] - 96, star_c[1] - 10), (star_c[0] - 36, star_c[1] - 58)], fill=HUB + (255,), width=16)

    return im


if __name__ == "__main__":
    im = draw_wheel()
    im = rounded(im, 192)
    out = r"..\app\assets\icon\app_icon.png"
    im.save(out)
    print("saved:", out)
