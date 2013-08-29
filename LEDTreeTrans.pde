import oscP5.*;
import netP5.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import themidibus.*;

import processing.opengl.*;
import hypermedia.net.*;
import java.util.concurrent.*;

import java.util.*;

OscP5 osc;  

/////////// Configuration Options /////////////////////

// Network configuration
String transmit_address = "127.0.0.1";  // Default 127.0.0.1
int transmit_port       = 58082;        // Default 58802, simlator on +1

// Display configuration
int displayHeight = 320;                // 160 for full-height strips
int displayWidth  = 40;                 // 8* number of control boxes

float bright = 1;                       // Global brightness modifier
String midiInputName = "IAC Bus 1";

///////////////////////////////////////////////////////
float brightnessPhase;

HashMap<String, Pattern> availablePatterns;  // List of available patterns to draw

List<Node> nodes;  // Our geometry
List<Edge> edges;
Fixture arch;

float displayRotation = 0; // For automatic display rotation

int currentEdge = -1;   // Node actively being configured

int layerCount = 3;  // Number of animation layers we can draw to
List<List<Pattern>> layers;

LinkedBlockingQueue<MidiMessage> noteOnMessages;    // 'On' messages that we need to handle
LinkedBlockingQueue<MidiMessage> noteOffMessages;   // 'Off' messages that we need to handle

PGraphics     frame;    // Image frame that gets sent to the LED display
LEDDisplay    display;  // Networked display output
MidiBus       myBus;    // MIDI input

PeasyCam pCamera;

void setup() {
  size(1024, 768, OPENGL);
//  size(1680, 1050, OPENGL);
  colorMode(RGB, 255);
  frameRate(60);
  
  osc = new OscP5(this,5600);
  
  pCamera = new PeasyCam(this, 0, 1.2, 0, 4);
  pCamera.setMinimumDistance(2);
  pCamera.setMaximumDistance(10);
  pCamera.setWheelScale(.5);

//  pCamera.rotateX(-.1);
  pCamera.rotateY(1.6);
//  pCamera.rotateZ(3);
  pCamera.rotateZ(3.14159);
  
  // Fix the front clipping plane
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
            cameraZ/1000.0, cameraZ*10.0);
  
  frame = createGraphics(displayWidth, displayHeight, P3D);
  
  nodes = defineNodes();
  edges = defineEdges();
  arch = new Fixture(edges);

  availablePatterns = new HashMap<String, Pattern>();
  
  RGBStripes rgb = new RGBStripes();
  rgb.m_channel = 3;
  rgb.m_pitch   = 36;
  availablePatterns.put("RGB", rgb);

  Stripes stripes = new Stripes();
  stripes.m_channel = 3;
  stripes.m_pitch   = 37;
  availablePatterns.put("Stripes", stripes);
  
  BouncyThings bt = new BouncyThings();
  bt.m_channel = 3;
  bt.m_pitch   = 38;
  availablePatterns.put("BouncyThings", bt);

  WarpSpeedMrSulu warp = new WarpSpeedMrSulu();
  warp.m_channel = 3;
  warp.m_pitch   = 39;
  availablePatterns.put("Warp", warp);
  
  RainbowColors rainbow = new RainbowColors();
  rainbow.m_channel = 3;
  rainbow.m_pitch   = 40;
  availablePatterns.put("Rainbow", rainbow);

  for (Map.Entry r : availablePatterns.entrySet()) {
    Pattern pat = (Pattern) r.getValue();
    pat.setup(this);
    pat.reset();
  }
  
  layers = new LinkedList<List<Pattern>>();

  for(int i = 0; i < layerCount; i++) {
    layers.add(new LinkedList<Pattern>());
  }

  display = new LEDDisplay(this, displayWidth, displayHeight, true, transmit_address, transmit_port);
  display.setAddressingMode(LEDDisplay.ADDRESSING_HORIZONTAL_NORMAL);  
  display.setEnableGammaCorrection(true);

  noteOnMessages = new LinkedBlockingQueue<MidiMessage>();
  noteOffMessages = new LinkedBlockingQueue<MidiMessage>();

  myBus = new MidiBus(this, midiInputName, -1);  
}

void updatePatterns() {
  // Convert midi 'on' messages to new patterns
  while (noteOnMessages.size () > 0) {
    MidiMessage m = noteOnMessages.poll();
    println("on " + m.m_channel + " " + m.m_pitch);
    switch(m.m_channel) {

    case 0:  // Channel 1: Light a single edge
      int edge = m.m_pitch - 36;
      if (edge >= 0 && edge < edges.size()) {
        layers.get(2).add(new FlashingEdge(edges.get(edge), m.m_channel, m.m_pitch, m.m_velocity));
      }
      break;
    
    case 1: // Channel 2: light a node
      int node = m.m_pitch - 36;
      if (node >= 0 && node < nodes.size()) {
        layers.get(1).add(new PulsingNode(nodes.get(node), m.m_channel, m.m_pitch, m.m_velocity));
      }
      break;

    case 2: // Channel 3: Fuck yeah!
      layers.get(0).add(new ThreeDFlood());
      break;

    case 3: // Channel 4: enable patterns
      for (Map.Entry p : availablePatterns.entrySet()) {
        Pattern pat = (Pattern) p.getValue();
        if (pat.m_channel == m.m_channel && pat.m_pitch == m.m_pitch && !layers.get(0).contains(pat)) {
          println("Adding " + pat);
          layers.get(0).add(pat);
        }
      }
      break;
    }
  }
  
  // Clear patterns that we got a midi off message for
  while (noteOffMessages.size () > 0) {
    MidiMessage m = noteOffMessages.poll();

    for(List<Pattern> l : layers) {
      Iterator<Pattern> it0 = l.iterator();
      while (it0.hasNext ()) {
        Pattern p = it0.next();
        if (p.m_channel == m.m_channel && p.m_pitch == m.m_pitch) {
          it0.remove();
          println("removing " + it0);
        }
      }
    }
  }
  
  // 'Panic' button, clear all existing patterns
  if (keyPressed && key == '`') {
    // clear everything
    for(List<Pattern> l : layers) {
      l.clear();
    }
    for(Edge e : edges) {
      e.paint(frame, color(0,0,0));
    }
  }
}

void paintPatterns() {
  // For every layer, draw each pattern in the order 
  frame.beginDraw();
  frame.background(0);
  for(List<Pattern> l : layers) {
    for (Pattern p : l) {
      p.paint(frame);
    }
  }
  
  // If we're configuring it, paint the active pattern
  if(currentEdge >= 0) {
    // Fill the current strip with a blue line
    frame.pushStyle();
      frame.stroke(color(0,0,255));
      frame.noSmooth();
      frame.line(edges.get(currentEdge).m_strip+1, 0, edges.get(currentEdge).m_strip+1, displayHeight);
    frame.popStyle();
    
    for(int i = 0; i < edges.get(currentEdge).m_length; i++) {
      if (i < 16) {
        edges.get(currentEdge).paint(frame, i, color(255,0,255));
      }
      else {
        edges.get(currentEdge).paint(frame, i, color(255,255,0));
      }
    }
  }
  frame.endDraw();
}

void draw() {
  background(color(0,0,40));
  for(Edge e : edges) {
    e.paint(frame, color(0));
  }
  
  updatePatterns();
  paintPatterns();

  // Draw the ground
  drawGround();
  
  // Draw the tree
  arch.draw();
  
  // Draw node names
  for (Node node : nodes) { 
    node.draw();
  }

  // draw a hud
  drawHud(frame);
  
  // Finally send the thing
  display.sendData(frame);
  
  
  bright = (sin(brightnessPhase) +3)/4;
  brightnessPhase += .5;

  // Rotate slowly
  pCamera.setRotations(0,displayRotation+=.006,3.14159);
}


void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  // println("On  " + channel + " " + pitch + " " + velocity);
  noteOnMessages.add(new MidiMessage(channel, pitch, velocity));
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  //println("Off " + channel + " " + pitch + " " + velocity);
  noteOffMessages.add(new MidiMessage(channel, pitch, velocity));
}

// Inject patterns for now, since we don't have a MIDI interface maybe
void keyPressed() {  
//  if (key == CODED) {
//    if (keyCode == UP) {
//      edges.get(currentEdge).m_offset += 1;
//    }
//    if (keyCode == DOWN) {
//      // TODO: Make this not go over bounds?
//      edges.get(currentEdge).m_offset -= 1;
//    }
//    if (keyCode == LEFT) {
//      // TODO: Make this not go over bounds?
//      edges.get(currentEdge).m_strip -= 1;
//    }
//    if (keyCode == RIGHT) {
//      // TODO: Make this not go over bounds?
//      edges.get(currentEdge).m_strip += 1;
//    }
//  }
  if (key == '/') {
    edges.get(currentEdge).m_flipped = !edges.get(currentEdge).m_flipped;
  }
  if (key == '+' || key == '=') {
    if(currentEdge >= 0) {
      edges.get(currentEdge).paint(frame, color(0,0,0));
    }

    currentEdge = min(edges.size() - 1, currentEdge + 1);
  }
  if (key == '-') {
    edges.get(currentEdge).paint(frame, color(0,0,0));
    currentEdge = max(0, currentEdge - 1);
  }
  
  if (key >= '1' && key <= '9') {
    // inject patterns so we have something to look at
    noteOnMessages.add(new MidiMessage(3, key - '1' + 36, 0));
  }
  if (key == '.') {
    //dump state
    println("// Start of edge defines");
    for(Edge e : edges) {
      e.dumpConfig();
    } 
    println("// End of edge defines");
  }
  if (key >= 'a' && key <= 'z') {
    // inject a strip pattern
    noteOnMessages.add(new MidiMessage(1, key - 'a' + 36, 0));
  }
  if (key >= 'A' && key <= 'Z') {
    // inject a strip pattern
    noteOnMessages.add(new MidiMessage(1, key - 'A' + 36 + 26, 0));
  }
  if (key == ',') {  // sweet pattern
    noteOnMessages.add(new MidiMessage(2, key - 'a' + 36, 0));
  }
}
