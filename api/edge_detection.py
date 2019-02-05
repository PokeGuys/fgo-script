import time
import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt

tic = time.perf_counter()

img = cv.imread('./debug/debug_1540048602016433800_960.png', 0)
template = cv.imread('./debug/weak-gray.png', 0)
template = cv.Canny(template, 10, 60)
(tH, tW) = template.shape[:2]
cv.imshow("Template", template)

regions = [
    (int(500 / 2), int(80 / 2), int(300 / 2), int(400 / 2)),
    (int(850 / 2), int(80 / 2), int(300 / 2), int(400 / 2)),
    (int(1200 / 2), int(80 / 2), int(300 / 2), int(400 / 2)),

    (int(60 / 2), int(530 / 2), int(300 / 2), int(400 / 2)),
    (int(445 / 2), int(530 / 2), int(300 / 2), int(400 / 2)),
    (int(830 / 2), int(530 / 2), int(300 / 2), int(400 / 2)),
    (int(1215 / 2), int(530 / 2), int(300 / 2), int(400 / 2)),
    (int(1600 / 2), int(530 / 2), int(300 / 2), int(400 / 2))
]

Card = []

i = 0
for r in regions:
    w, h = r[2:]
    cropped = img[r[1]:r[1]+h, r[0]:r[0]+w]
    edged = cv.Canny(cropped, 50, 200)
    result = cv.matchTemplate(edged, template, cv.TM_CCOEFF)
    (_, maxVal, _, maxLoc) = cv.minMaxLoc(result)
    cv.rectangle(cropped, (maxLoc[0], maxLoc[1]), (maxLoc[0] + tW, maxLoc[1] + tH), 255, 2)
    Card.append(cropped)
    i += 1
print(time.perf_counter() - tic)
cv.imshow('Card', np.concatenate(Card, axis=1))
cv.waitKey(0)

