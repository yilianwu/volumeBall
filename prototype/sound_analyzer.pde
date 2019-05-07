import processing.serial.*;
import processing.sound.*;
AudioIn input;
Amplitude analyzer;
Serial myPort;
void setup(){
  frameRate(30);
  input=new AudioIn(this,0);
  input.start();
  analyzer=new Amplitude(this);
  analyzer.input(input);
  myPort=new Serial(this,"/dev/cu.usbmodem1411",9600);
}

void draw(){
  float vol=analyzer.analyze();
  float num=map(vol,0,1,0,180); 
  myPort.write(int(num));
  println(num);
}