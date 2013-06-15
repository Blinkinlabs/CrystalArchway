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
    
    fill(255);
    textSize(24);
    text(frameRate, hudX + displayWidth+4, height - 10); 
  popStyle();
  pCamera.endHUD();
}
