import cv2 as cv
import numpy as np

if __name__ == '__main__':
    img = cv.imread('debug/40418153-2b90f8da-5eb4-11e8-9a8e-0a0c3343b033.png')
    img = cv.resize(img, None, fx=0.3, fy=0.3)

    img_gray = cv.cvtColor(img, cv.COLOR_RGB2GRAY)
    _, img_bin = cv.threshold(img_gray, 127, 255, cv.THRESH_BINARY)
    image, contours, hierarchy = cv.findContours(img_bin, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    areas = [cv.contourArea(contour) for contour in contours]
    max_index = np.argmax(areas)
    cnt = contours[max_index]
    x, y, w, h = cv.boundingRect(cnt)
    # # Crop with the largest rectangle
    crop = img[y:y+h, x:x+w]
    cv.imwrite('final.png', crop)
    imagePreview = cv.imread('debug/40418153-2b90f8da-5eb4-11e8-9a8e-0a0c3343b033.png')
    imagePreview = cv.resize(imagePreview, None, fx=0.3, fy=0.3)
    for contour in contours:
        #epsilon = 0.001 * cv2.arcLength(contour,True)
        #cv2.drawContours(imagePreview, [cv2.approxPolyDP(contour, epsilon, True)], 0, (0,255,0), 1)
        cv.drawContours(imagePreview, [contour], 0, (0, 255, 0), 1)
    cv.imshow("globalThreshold", img_bin)
    cv.imshow("drawContours", imagePreview)
    cv.imshow("cropped", crop)
    cv.waitKey(0)
    cv.destroyAllWindows()
