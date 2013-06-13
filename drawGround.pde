void drawGround() {
  stroke(92, 51);
  fill(92, 51);
  
  int tilefactor = 20;
  float bound = 20;

  for (int x = 0; x < tilefactor; x++) {
    for (int y = 0; y < tilefactor; y++) {
      pushMatrix();
      translate(0, -0.5, 0);
      
      translate(bound/tilefactor*x-bound/2, 0, bound/tilefactor*y-bound/2);
      
      beginShape();
      vertex(0,                .5, 0               );
      vertex(bound/tilefactor, .5, 0               );
      vertex(bound/tilefactor, .5, bound/tilefactor);
      vertex(0,                .5, bound/tilefactor);
      endShape();
      popMatrix();
    }
  }
}
