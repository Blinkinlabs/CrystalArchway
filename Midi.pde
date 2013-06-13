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

