// Adapted from articles, by Daniel Shiffman.

class LED {

  PVector velocity;
  float lifespan = 255;
  
  PShape part;
  float partSize;

  LED(float x, float y, float z, PImage sprite) {
    partSize = 20;
    
    part = createShape();
    part.beginShape(QUAD);
      part.noStroke();
      part.texture(sprite);
    
      // TODO: Translate this so the LED faces in the correct direction; also, define the correct direction!
      part.vertex(x-partSize/2, y-partSize/2, z, 0,            0);
      part.vertex(x+partSize/2, y-partSize/2, z, sprite.width, 0);
      part.vertex(x+partSize/2, y+partSize/2, -z, sprite.width, sprite.height);
      part.vertex(x-partSize/2, y+partSize/2, -z, 0,            sprite.height);
    part.endShape(); 
  }

  PShape getShape() {
    return part;
  }
  

  public void update(color c) {
    part.setTint(c);
  }
}
