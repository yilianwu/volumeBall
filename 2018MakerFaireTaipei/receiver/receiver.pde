import cc.arduino.*;
import org.firmata.*;
import netP5.*;
import oscP5.*;
import processing.serial.*;
OscP5 oscP5;
Arduino arduino;
int delayPin=9;
int megaDelay=3;
int dimmerPin=11;

float amplitude=0;
long preTime=0;
long interval=50;
int state=0;
long currentTime;

long megaPre=0;
long megaInterval=300;
int megaState=0;
long megaCurrent;

int level=0;

void setup() {
  frameRate(30);
  size(400, 120);
  oscP5=new OscP5(this, 12000);
  //println(Arduino.list());
  arduino = new Arduino(this, "/dev/cu.usbmodem1421", 57600);
  arduino.pinMode(delayPin, Arduino.OUTPUT);
  arduino.pinMode(dimmerPin,Arduino.OUTPUT);
  arduino.pinMode(megaDelay,Arduino.OUTPUT);
  arduino.digitalWrite(delayPin,Arduino.HIGH);
  arduino.digitalWrite(megaDelay,Arduino.HIGH);
  arduino.analogWrite(dimmerPin,225);
}
void draw() {
  megaCurrent=frameCount;
  currentTime=frameCount;
  println(currentTime);
  println(preTime);
  background(0);
  textSize(60);
  fill(255);
  textAlign(CENTER);
  text(amplitude, width/2, height/2);
    while( megaState==1 && megaCurrent-megaPre>megaInterval){
      println("TIME'S UP MEGA OFF!");
      //arduino.digitalWrite(megaDelay,Arduino.HIGH);
      megaState=0;
    }
    
    if(state==1 && currentTime-preTime>interval){
      println("TIME's UP!");
      state=0;
    }
    
    switch(megaState){
      case 0:
      arduino.digitalWrite(megaDelay, Arduino.HIGH);//relay ON
      println("MEGA OFF!!!!!!");
      break;
      
      case 1:
      arduino.digitalWrite(megaDelay, Arduino.LOW);//relay OFF
      println("MEGA ON!!!!!!");
      break;    
    }
    
    switch(state){
      case 0:
      arduino.digitalWrite(delayPin, Arduino.HIGH);//relay ON
      println("SHUT DOWN!!!!!!");
      break;
      
      case 1:
      arduino.digitalWrite(delayPin, Arduino.LOW);//relay OFF
      println("BLOW IT!!!!!!");
      break;    
    }
    
    
}
void oscEvent(OscMessage theOscMessage) {
  float value=theOscMessage.get(0).floatValue();
  if (theOscMessage.checkAddrPattern("/volume")) {
    
    println("volume : "+value);
    
    if (value>0.05 && value<0.5) {
      arduino.analogWrite(dimmerPin,246);
      interval=40;
      state=1;
      megaState=1;
      megaPre=megaCurrent;
      preTime=currentTime;
      amplitude=value;  
    } 
    
    else if(value>0.5 ){
      arduino.analogWrite(dimmerPin,220);
      interval=50;
      state=1;
      megaState=1;
      megaPre=megaCurrent;
      preTime=currentTime;
      amplitude=value;
      
    }
    
    else {
      amplitude=0.0;
    }
  }
}