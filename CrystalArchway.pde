import oscP5.*;
import netP5.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import hypermedia.net.*;
import java.util.concurrent.*;

import java.util.*;

OscP5 g_osc;

/////////// Configuration Options /////////////////////

// Network configuration
String g_transmit_address = "192.168.7.2";  // Default 127.0.0.1
int g_transmit_port       = 9999;        // Default 58802

// Display configuration
int displayHeight = 240;                // 160 for full-height strips
int displayWidth  = 32;                 // 8* number of control boxes

float g_bright = 1;                     // Global brightness modifier
float g_speed = 1;                      // Global speed modifier


// OSC configuration
int g_osc_receive_port = 8000;


///////////////////////////////////////////////////////
HashMap<String, Pattern> g_availablePatterns;  // List of available patterns to draw

List<Node> g_nodes;  // Our geometry
List<Edge> g_edges;
Fixture    g_arch;

float g_displayRotation = 0; // For automatic display rotation

int currentEdge = -1;   // Node actively being configured

int g_layerCount = 3;  // Number of animation layers we can draw to
List<List<Pattern>> g_layers;

LinkedBlockingQueue<OscMessage> g_oscMessages;   // OSC messages that we received

PGraphics     g_frame;    // Image frame that gets sent to the LED display
LEDDisplay    g_display;  // Networked display output


PeasyCam g_pCamera;

void setup() {
  size(1024, 768, OPENGL);
  //  size(1680, 1050, OPENGL);
  colorMode(RGB, 255);
  frameRate(60);

  g_osc = new OscP5(this, g_osc_receive_port);  // Start a new OSC listener

  g_pCamera = new PeasyCam(this, 0, 1.2, 0, 4);
  g_pCamera.setMinimumDistance(2);
  g_pCamera.setMaximumDistance(4);
  g_pCamera.setWheelScale(.1);

  g_pCamera.rotateY(1.6);
  g_pCamera.rotateZ(PI);

  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
  cameraZ/1000.0, cameraZ*10.0);

  g_frame = createGraphics(displayWidth, displayHeight);
  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  hint(DISABLE_DEPTH_MASK);

  g_nodes = defineNodes();
  g_edges = defineEdges();
  g_arch = new Fixture(g_edges);

  g_availablePatterns = new HashMap<String, Pattern>();

  RGBStripes rgb = new RGBStripes();
  g_availablePatterns.put("RGB", rgb);

  Stripes stripes = new Stripes();
  g_availablePatterns.put("Stripes", stripes);

  BouncyThings bt = new BouncyThings();
  g_availablePatterns.put("BouncyThings", bt);

  RainbowColors rainbow = new RainbowColors();
  g_availablePatterns.put("Rainbow", rainbow);

  Stars stars = new Stars();
  g_availablePatterns.put("Stars", stars);

  ThreeDFunction threed = new ThreeDFunction();
  g_availablePatterns.put("ThreeDFunction", threed);

  for (Map.Entry r : g_availablePatterns.entrySet()) {
    Pattern pat = (Pattern) r.getValue();
    pat.setup(this);
    pat.reset();
  }

  g_layers = new LinkedList<List<Pattern>>();

  for (int i = 0; i < g_layerCount; i++) {
    g_layers.add(new LinkedList<Pattern>());
  }

  g_display = new LEDDisplay(this, displayWidth, displayHeight, true, g_transmit_address, g_transmit_port);
  g_display.setAddressingMode(LEDDisplay.ADDRESSING_HORIZONTAL_NORMAL);  
  g_display.setEnableGammaCorrection(true);

  g_oscMessages = new LinkedBlockingQueue<OscMessage>();
}

void updatePatterns() {
  // TODO: only handle messages that we already received
  while (g_oscMessages.size () > 0) {
    OscMessage m = g_oscMessages.poll();

    // Handle system patterns
    if (m.checkAddrPattern("/system/bright")==true) {
      g_bright = m.get(0).floatValue();
    }

    // Handle pattern on/off
    if (m.addrPattern().startsWith("/PatternOnOff")) {
      println("Here: " + m.addrPattern());
    }

    if (m.checkAddrPattern("/PatternOnOff/EnableStars")==true) {
      Pattern stars = (Pattern) g_availablePatterns.get("Stars");
      if (m.get(0).floatValue() >0) {
        if (!g_layers.get(0).contains(stars)) {
          stars.reset();
          g_layers.get(0).add(stars);
        }
      }
      else {
        if (g_layers.get(0).contains(stars)) {
          g_layers.get(0).remove(stars);
        }
      }
    }
    
    if (m.checkAddrPattern("/PatternOnOff/ThreeDFunction")==true) {
      Pattern threed = (Pattern) g_availablePatterns.get("ThreeDFunction");
      if (m.get(0).floatValue() >0) {
        if (!g_layers.get(0).contains(threed)) {
          threed.reset();
          g_layers.get(0).add(threed);
        }
      }
      else {
        if (g_layers.get(0).contains(threed)) {
          g_layers.get(0).remove(threed);
        }
      }
//      g_layers.get(0).add(new RainbowColors());
    }
  }


  // 'Panic' button, clear all existing patterns
  if (keyPressed && key == '`') {
    // clear everything
    for (List<Pattern> l : g_layers) {
      l.clear();
    }
    for (Edge e : g_edges) {
      e.paint(g_frame, color(0, 0, 0));
    }
  }
}

void paintPatterns() {
  // For every layer, draw each pattern in the order 
  g_frame.beginDraw();
  g_frame.background(0,0,255);
  for (List<Pattern> l : g_layers) {
    for (Pattern p : l) {
      p.paint(g_frame);
    }
  }

  // If we're configuring it, paint the active pattern
  if (currentEdge >= 0) {
    // Fill the current strip with a blue line
    g_frame.pushStyle();
    g_frame.stroke(color(0, 0, 255));
    g_frame.noSmooth();
    g_frame.line(g_edges.get(currentEdge).m_strip+1, 0, g_edges.get(currentEdge).m_strip+1, displayHeight);
    g_frame.popStyle();

    for (int i = 0; i < g_edges.get(currentEdge).m_length; i++) {
      if (i < 16) {
        g_edges.get(currentEdge).paint(g_frame, i, color(255, 0, 255));
      }
      else {
        g_edges.get(currentEdge).paint(g_frame, i, color(255, 255, 0));
      }
    }
  }
  g_frame.endDraw();
}

void draw() {
  
  background(color(0, 0, 40));

  for (Edge e : g_edges) {
    e.paint(g_frame, color(0));
  }

  updatePatterns();
  paintPatterns();

  // Draw the ground
  drawGround();

  // Draw the tree
  g_arch.draw();

  // Draw node names
  for (Node node : g_nodes) { 
    node.draw();
  }

  // draw a hud
  drawHud(g_frame);

  // Finally send the thing
  g_display.sendData(g_frame);

  // Rotate slowly
  g_pCamera.setRotations(0, g_displayRotation+=.004, PI);
}

// Inject patterns for now, since we don't have a MIDI interface maybe
void keyPressed() {  
  //  if (key == CODED) {
  //    if (keyCode == UP) {
  //      g_edges.get(currentEdge).m_offset += 1;
  //    }
  //    if (keyCode == DOWN) {
  //      // TODO: Make this not go over bounds?
  //      g_edges.get(currentEdge).m_offset -= 1;
  //    }
  //    if (keyCode == LEFT) {
  //      // TODO: Make this not go over bounds?
  //      g_edges.get(currentEdge).m_strip -= 1;
  //    }
  //    if (keyCode == RIGHT) {
  //      // TODO: Make this not go over bounds?
  //      g_edges.get(currentEdge).m_strip += 1;
  //    }
  //  }
  //  if (key == '/') {
  //    g_edges.get(currentEdge).m_flipped = !g_edges.get(currentEdge).m_flipped;
  //  }
  //  if (key == '+' || key == '=') {
  //    if(currentEdge >= 0) {
  //      g_edges.get(currentEdge).paint(g_frame, color(0,0,0));
  //    }
  //
  //    currentEdge = min(g_edges.size() - 1, currentEdge + 1);
  //  }
  //  if (key == '-') {
  //    g_edges.get(currentEdge).paint(g_frame, color(0,0,0));
  //    currentEdge = max(0, currentEdge - 1);
  //  }

  if (key >= '1' && key <= '9') {
    // Enable the nth pattern in the availablePatterns list???
    
    if(key == '1') {
      OscMessage m = new OscMessage("/PatternOnOff/EnableStars");
      m.add(1.0);     
      g_oscMessages.add(m);
    }
    else if(key == '2') {
      OscMessage m = new OscMessage("/PatternOnOff/ThreeDFunction");
      m.add(1.0);     
      g_oscMessages.add(m);      
    }
  }
  if (key == '.') {
    //dump state
    println("// Start of edge defines");
    for (Edge e : g_edges) {
      e.dumpConfig();
    } 
    println("// End of edge defines");
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  g_oscMessages.add(theOscMessage);
}

