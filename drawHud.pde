void drawHud(PGraphics f) {
  pCamera.beginHUD();
  pushStyle();
  
    // Show the current frame
    int hudX = 10;
    int hudY = height - 10 - displayHeight;
    stroke(255);
    strokeWeight(1);
    fill(0);
    rect(hudX,hudY,displayWidth,displayHeight);
    image(f, hudX, hudY);

    // show framerate
    fill(255);
    textSize(24);
    text(frameRate, hudX + displayWidth+4, height - 10);
    
    // And the current patterns
    fill(255);
    textSize(16);
    float x = textWidth(" ");
    float y = textAscent();
    for(List<Pattern> l : layers) {
      for (Pattern p : l) {
        text(p.m_name, x,y);
        y += textAscent() + textDescent();
      }
    }
    
    
 
  popStyle();
  pCamera.endHUD();
}
