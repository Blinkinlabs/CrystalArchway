
import java.nio.*;
import javax.media.opengl.*;
import com.jogamp.common.nio.*;


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
  
  // For low-level openGL version
  FloatBuffer m_vbuffer;
  FloatBuffer m_cbuffer;
  
  // For PShape version
  ArrayList<LED> LEDs;
  PShape ledShape;
  
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
    m_length = 60;  // For simplicity
    m_startNode = startNode + nodeOffset;
    m_endNode = endNode + nodeOffset;
    
    m_pixels = new color[m_length];
    
    computeLightPositionsGL();
//    makeLEDParticles();
  }
  
  void makeLEDParticles() {
    // TODO: Do this globally since we only have one image
    PImage sprite = loadImage("sprite.png");
    
    LEDs = new ArrayList<LED>();
    ledShape = createShape(PShape.GROUP);

    for (int i = 0; i < m_length; i++) {
      float x = g_nodes.get(m_startNode).m_posX - (g_nodes.get(m_startNode).m_posX - g_nodes.get(m_endNode).m_posX)/m_length*i;
      float y = g_nodes.get(m_startNode).m_posY - (g_nodes.get(m_startNode).m_posY - g_nodes.get(m_endNode).m_posY)/m_length*i;
      float z = g_nodes.get(m_startNode).m_posZ - (g_nodes.get(m_startNode).m_posZ - g_nodes.get(m_endNode).m_posZ)/m_length*i;
      
      LED p = new LED(x, y, z, sprite);
      LEDs.add(p);
      ledShape.addChild(p.getShape());
    }
  }
  
  void computeLightPositionsGL() {
    GL gl = g.beginPGL().gl;

    m_vbuffer = Buffers.newDirectFloatBuffer(m_length * 3);
    m_cbuffer = Buffers.newDirectFloatBuffer(m_length * 3);

    for (int i = 0; i < m_length; i++) {
      float x = g_nodes.get(m_startNode).m_posX - (g_nodes.get(m_startNode).m_posX - g_nodes.get(m_endNode).m_posX)/m_length*i;
      float y = g_nodes.get(m_startNode).m_posY - (g_nodes.get(m_startNode).m_posY - g_nodes.get(m_endNode).m_posY)/m_length*i;
      float z = g_nodes.get(m_startNode).m_posZ - (g_nodes.get(m_startNode).m_posZ - g_nodes.get(m_endNode).m_posZ)/m_length*i;

      m_vbuffer.put(x);
      m_vbuffer.put(y);
      m_vbuffer.put(z);

    }
    m_vbuffer.rewind();

    g.endPGL();
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
    f.set(m_strip, m_offset + position, c);   
  }
  
  void drawGL() {
    // Upload the new color data
    for (int i = 0; i < m_length; i++) { 
      // set the color based on the image data
      color c = m_pixels[i];
      
      m_cbuffer.put(red(c)/255.0);
      m_cbuffer.put(green(c)/255.0);
      m_cbuffer.put(blue(c)/255.0);
    }
    m_cbuffer.rewind();

    PGraphicsOpenGL pg = ((PGraphicsOpenGL)g);
    PGL pgl = pg.beginPGL();
    GL2 gl2 = pgl.gl.getGL2();

    gl2.glEnableClientState(GL2.GL_VERTEX_ARRAY);
    gl2.glVertexPointer(3, GL2.GL_FLOAT, 0, m_vbuffer);
 
    gl2.glEnableClientState(GL2.GL_COLOR_ARRAY);
    gl2.glColorPointer(3, GL2.GL_FLOAT, 0, m_cbuffer);
    
//    gl2.glEnable(GL2.GL_POINT_SPRITE);
//    gl2.glTexEnvi(GL2.GL_POINT_SPRITE, GL2.GL_COORD_REPLACE, GL2.GL_TRUE); 

    gl2.glPushMatrix();
      gl2.glPointSize(3);

      gl2.glDrawArrays(GL2.GL_POINTS, 0, m_length);
    gl2.glPopMatrix();

//    gl2.glDisable(GL2.GL_POINT_SPRITE);

    gl2.glDisableClientState(GL2.GL_VERTEX_ARRAY);
    gl2.glDisableClientState(GL2.GL_COLOR_ARRAY);

    g.endPGL();
  }
  
  void drawParticles() {
    for (int i = 0; i < m_length; i++) { 
      LEDs.get(i).update(color(m_pixels[i]));
    }
    
    shape(ledShape);
  }
  
  void draw() {
    drawGL();
//    drawParticles();
  }
  
  PVector getCentroid() {
    float x = (g_nodes.get(m_startNode).m_posX + g_nodes.get(m_endNode).m_posX) / 2;
    float y = (g_nodes.get(m_startNode).m_posY + g_nodes.get(m_endNode).m_posY) / 2;
    float z = (g_nodes.get(m_startNode).m_posZ + g_nodes.get(m_endNode).m_posZ) / 2;
    
    return new PVector(x,y,z);
  }
  
  PVector getPixelCoordinates(int position) {
    float x = g_nodes.get(m_startNode).m_posX - (g_nodes.get(m_startNode).m_posX - g_nodes.get(m_endNode).m_posX)/m_length*position;
    float y = g_nodes.get(m_startNode).m_posY - (g_nodes.get(m_startNode).m_posY - g_nodes.get(m_endNode).m_posY)/m_length*position;
    float z = g_nodes.get(m_startNode).m_posZ - (g_nodes.get(m_startNode).m_posZ - g_nodes.get(m_endNode).m_posZ)/m_length*position;
    
    return new PVector(x,y,z);
  }
  
  void dumpConfig() {
    System.out.printf("  Edges.add(new Edge( %3d, %3d, %3d, %5b, %3d, %3d,  0));\n",
                      m_name, m_strip, m_offset, m_flipped, m_startNode, m_endNode);

  }
}

