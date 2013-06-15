class Edge {
  // Mapping into the strip image array
  int m_strip;
  int m_offset;
  int m_length;
  boolean m_flipped;

  // mapping into the graph array
  int m_name;
  int m_startNode;
  int m_endNode;
  
  
  color[] m_pixels;

  // For LED Tree edges
  // @param name Name of the edge
  // @param strip Strip number (0-7, one for each bb8 output)
  // @param offset 
  // @param startNode Node that the edge starts at
  // @param endNode Node that the edge ends at
  // @param number to add to the start and end nodes (for making repetitive structures)
  Edge(int name, int strip, int offset, boolean flipped, int startNode, int endNode, int nodeOffset) {
    m_name = name;
    m_strip = strip;
    m_offset = offset;
    m_flipped = flipped;
    m_length = 31;  // For simplicity
    m_startNode = startNode + nodeOffset;
    m_endNode = endNode + nodeOffset;
    
    m_pixels = new color[m_length];
  }

  // Paint a solid color along the whole edge
  void paint(PGraphics f, color c) {    
    f.pushStyle();
      f.stroke(c);
      f.strokeWeight(1);
      f.noSmooth();
      f.line(m_strip+1, m_offset, m_strip+1, m_offset + m_length);
    f.popStyle();
     
    for(int i = 0; i < m_length; i++) {
      m_pixels[i] = c;
    }
  }
  
  // Draw a dot at a single pixel position
  void paint(PGraphics f, int position, color c) {
    m_pixels[position] = c; 
    if(m_flipped) {
      position = m_length - 1 - position;
    }
   
//    f.pushStyle();
//      f.stroke(c);
//      f.strokeWeight(2);
//      f.noSmooth();
      f.set(m_strip, m_offset + position, c);
//    f.popStyle();   
  }
  
  
  void draw() {
    for (int i = 0; i < m_length; i++) { 
  
      // Calculate the location based on the end points
      float x = nodes.get(m_startNode).m_posX - (nodes.get(m_startNode).m_posX - nodes.get(m_endNode).m_posX)/m_length*i;
      float y = nodes.get(m_startNode).m_posY - (nodes.get(m_startNode).m_posY - nodes.get(m_endNode).m_posY)/m_length*i;
      float z = nodes.get(m_startNode).m_posZ - (nodes.get(m_startNode).m_posZ - nodes.get(m_endNode).m_posZ)/m_length*i;
      
      // set the color based on the image data
//      color c = imageData[m_strip + (m_offset + i)*strips];
      // set the color based on the strip data
      color c = m_pixels[i];
      
      // Draw the individual LEDs
      pushMatrix();
        translate(x, y, z);
        stroke(c);
        fill(c);
//        //scale(rad);
        ellipse(0,0,.02,.02);
//        point(0,0);
      popMatrix();
    }
  }
  
  PVector getPixelCoordinates(int position) {
    float x = nodes.get(m_startNode).m_posX - (nodes.get(m_startNode).m_posX - nodes.get(m_endNode).m_posX)/m_length*position;
    float y = nodes.get(m_startNode).m_posY - (nodes.get(m_startNode).m_posY - nodes.get(m_endNode).m_posY)/m_length*position;
    float z = nodes.get(m_startNode).m_posZ - (nodes.get(m_startNode).m_posZ - nodes.get(m_endNode).m_posZ)/m_length*position;
    
    return new PVector(x,y,z);
  }
  
  void dumpConfig() {
    System.out.printf("  Edges.add(new Edge( %3d, %3d, %3d, %5b, %3d, %3d,  0));\n",
                      m_name, m_strip, m_offset, m_flipped, m_startNode, m_endNode);

  }
}

