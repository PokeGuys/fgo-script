import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt

img = cv.imread('./debug/debug_1540048602016433800_960.png', 0)
template = cv.imread('./debug/weak-gray.png', 0)
template_edged = cv.Canny(template, 10, 60)
(tH, tW) = template.shape[:2]

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
CardEdged = []
for r in regions:
    w, h = r[2:]
    cropped = img[r[1]:r[1]+h, r[0]:r[0]+w]
    cloned_cropped = cropped.copy()
    cropped_edged = cv.Canny(cloned_cropped, 50, 200)
    res = cv.matchTemplate(cropped, template, cv.TM_CCOEFF_NORMED)
    edged_res = cv.matchTemplate(cropped_edged, template_edged, cv.TM_CCOEFF_NORMED)
    (_, maxVal, _, maxLoc) = cv.minMaxLoc(edged_res)
    cv.rectangle(cloned_cropped, (maxLoc[0], maxLoc[1]), (maxLoc[0] + tW, maxLoc[1] + tH), 255, 2)
    CardEdged.append(cloned_cropped)

    threshold = 0.7
    loc = np.where(res >= threshold)
    for pt in zip(*loc[::-1]):
        bottom_right = (pt[0] + tW, pt[1] + tH)
        cv.rectangle(cropped, pt, bottom_right, 255, 2)
    Card.append(cropped)

cv.imshow('matchTemplate', np.concatenate(Card, axis=1))
cv.imshow('Canny', np.concatenate(CardEdged, axis=1))
cv.waitKey(0)
