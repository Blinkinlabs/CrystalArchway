void drawHud(PGraphics f) {
  pCamera.beginHUD();
  pushStyle();
    int hudX = 10;
    int hudY = height - 10 - displayHeight;
    stroke(255);
    strokeWeight(1);
    fill(0);
    rect(hudX,hudY,displayWidth,displayHeight);
    image(f, hudX, hudY);
  popStyle();
  pCamera.endHUD();
}
