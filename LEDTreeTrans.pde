import themidibus.*;

import processing.opengl.*;
import hypermedia.net.*;
import java.util.concurrent.*;

/////////// Configuration Options /////////////////////

// Network configuration
String transmit_address = "127.0.0.1";  // Default 127.0.0.1
int transmit_port       = 58082;        // Default 58802

// Display configuration
int displayHeight = 160;                // 160 for full-height strips
int displayWidth  = 40;                 // 8* number of control boxes

float bright = 1;                       // Global brightness modifier
String midiInputName = "IAC Bus 1";

///////////////////////////////////////////////////////

long modeFrameStart;

HashMap<String, Pattern> enabledPatterns;

List<Node> Nodes;
List<Edge> Edges;

int rectX = 100;
int rectY = 100;


class MidiMessage {
  public int m_channel;
  public int m_pitch;
  public int m_velocity;

  MidiMessage(int channel, int pitch, int velocity) {
    m_channel = channel;
    m_pitch = pitch;
    m_velocity = velocity;
  }
}

int layerCount = 3;
List<List<Pattern>> layers;

LinkedBlockingQueue<MidiMessage> noteOnMessages;    // 'On' messages that we need to handle
LinkedBlockingQueue<MidiMessage> noteOffMessages;   // 'Off' messages that we need to handle

LEDDisplay    display;
MidiBus       myBus;

void setup() {
  size(600, 350);
  frameRate(5);
  
  defineNodes();
  defineEdges();

  enabledPatterns = new HashMap<String, Pattern>();
  
  RGBStripes rgb = new RGBStripes();
  rgb.m_channel = 3;
  rgb.m_pitch   = 36;
  enabledPatterns.put("RGB", rgb);

  Stripes stripes = new Stripes();
  stripes.m_channel = 3;
  stripes.m_pitch   = 37;
  enabledPatterns.put("Stripes", stripes);
  
  BouncyThings bt = new BouncyThings();
  bt.m_channel = 3;
  bt.m_pitch   = 38;
  enabledPatterns.put("BouncyThings", bt);

  Warp warp = new Warp(new WarpSpeedMrSulu(), false, true, 0.5, 0.5);
  warp.m_channel = 3;
  warp.m_pitch   = 39;
  enabledPatterns.put("Warp", warp);
  
  RainbowColors rainbow = new RainbowColors();
  rainbow.m_channel = 3;
  rainbow.m_pitch   = 40;
  enabledPatterns.put("Rainbow", rainbow);

  for (Map.Entry r : enabledPatterns.entrySet()) {
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
  display.setEnableGammaCorrection(false);

  noteOnMessages = new LinkedBlockingQueue<MidiMessage>();
  noteOffMessages = new LinkedBlockingQueue<MidiMessage>();

  myBus = new MidiBus(this, midiInputName, -1);  

  modeFrameStart = frameCount;
}

void draw() {  
    background(0);

  // Convert midi 'on' messages to new patterns
  while (noteOnMessages.size () > 0) {
    MidiMessage m = noteOnMessages.poll();
    println("on " + m.m_channel + " " + m.m_pitch);
    switch(m.m_channel) {

    case 0:  // Channel 1: Light a single edge
      int edge = m.m_pitch - 36;
      if (edge >= 0 && edge < Edges.size()) {
        layers.get(2).add(new FlashingEdge(Edges.get(edge), m.m_channel, m.m_pitch, m.m_velocity));
      }
      break;
      
    case 1:  // Channel 2: Light entire LED strips
      layers.get(0).add(new SolidStrip(m.m_channel, m.m_pitch, m.m_velocity));
      break;

    case 2:  // Channel 3: Flash a color over the whole display
      layers.get(0).add(new ScreenFlash(m.m_channel, m.m_pitch, m.m_velocity));
      break;

    case 3: // Channel 4: enable patterns
      for (Map.Entry p : enabledPatterns.entrySet()) {
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
  
  pushStyle();
    fill(255);
    noStroke();
    rect(rectX - 50, rectY - 50, 100, 100);
    strokeWeight(1);
    stroke(255);
    line(displayWidth + 1, 0, displayWidth + 1, height);
  popStyle();

  // Actually draw the patterns
  for(List<Pattern> l : layers) {
    for (Pattern p0 : l) {
      p0.draw();
    }
  }

  // 'Panic' button, clear all existing patterns
  if (keyPressed && key == 'c') {
    // clear everything
    for(List<Pattern> l : layers) {
      l.clear();
    }
  }

  display.sendData();
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

void mouseMoved() {
  rectX = mouseX;
  rectY = mouseY;
}

