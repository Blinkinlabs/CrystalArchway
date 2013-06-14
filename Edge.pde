class Edge {
  public int m_strip;
  public int m_offset;
  public int m_length;

  public int m_name;
  public int m_startNode;
  public int m_endNode;
  
  public color[] m_pixels;

  // For LED Tree edges
  // @param name Name of the edge
  // @param strip Strip number (0-7, one for each bb8 output)
  // @param offset 
  // @param startNode Node that the edge starts at
  // @param endNode Node that the edge ends at
  Edge(int name, int strip, int offset, int startNode, int endNode) {
    m_name = name;
    m_strip = strip;
    m_offset = offset;
    m_length = 31;  // For simplicity
    m_startNode = startNode;
    m_endNode = endNode;
    
    m_pixels = new color[m_length];
  }

  // Paint a solid color along the whole edge
  void paint(PGraphics f, color c) {
    f.pushStyle();
      // If we're calibrating, we want to paint gray first! how to make this without a hack?
//      f.stroke(color(50));
//      f.noSmooth();
//      f.line(m_strip, 0, m_strip, displayHeight);

      f.stroke(c);
      f.strokeWeight(1);
      f.noSmooth();
      f.line(m_strip, m_offset, m_strip, m_offset + m_length);
    f.popStyle();
     
    for(int i = 0; i < m_length; i++) {
      m_pixels[i] = c;
    }
  }
  
  // Draw a dot at a single pixel position
  void paint(PGraphics f, int position, color c) {
    m_pixels[position] = c;
    
    f.pushStyle();
      f.stroke(c);
      f.strokeWeight(1.01);
      f.noSmooth();
      f.point(m_strip, m_offset + position);
    f.popStyle();
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
  
  void dumpConfig() {
    System.out.printf("  Edges.add(new Edge( %3d, %3d, %3d, %3d, %3d));\n",
                      m_name, m_strip, m_offset, m_startNode, m_endNode);

  }
}

