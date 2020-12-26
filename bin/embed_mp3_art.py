from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw

import eyed3
import glob

eyed3.log.setLevel("ERROR")

for f in glob.glob('/'.join(['.', '*.mp3'])):
    hos = eyed3.load(f)
    title = hos.tag.title
    if title:
        split = title.split('-')
        if len(split) > 1:
            prog = split[0].strip()
            title = split[1].strip().title()
        else:
            prog = None
            title = split.strip().title()
    else:
        prog = None
        title = f

    print (f"Working with: {prog}: {title}...")

    img = Image.open("hos.jpg")
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype('NotoSans-Bold.ttf', 44)
    font2 = ImageFont.truetype('NotoSans-Regular.ttf', 52)

    pw, ph = draw.textsize(f"Prog: {prog}", font=font)
    tw, th = draw.textsize(f"{title}", font=font2)
    draw.text((1005 - 30 - pw, 820), f"Prog: {prog}", (255, 255, 255), font=font)
    draw.text((1005 - 30 - tw, 820 + ph), f"{title}", (255, 255, 255), font=font2)
    img.thumbnail((600, 600), Image.ANTIALIAS)
    img.save("out.jpg", format='JPEG', subsampling=0, quality=80)

    hos.tag.images.set(3, open('out.jpg','rb').read(), 'image/jpeg')
    hos.tag.save()