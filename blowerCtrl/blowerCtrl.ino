#include<Servo.h>
Servo myservo;
int pdin=0;
int myRelay=8;
bool myio;
int mytime=0;
void setup() {
  Serial.begin(9600);
  pinMode(myRelay,OUTPUT);
  myservo.attach(9);
  myservo.write(0);
  digitalWrite(myRelay,HIGH);
  myio=true;

}

void loop() {
   
  if(Serial.available()>0){
    pdin=Serial.read();
//    pdin=map(pdin,0,100,0,180);
  }
  if(pdin>0&&pdin<60){
    myservo.write(33);
  }
  if(pdin>59&&pdin<90){
    myservo.write(32);
  }
  else if(pdin>90&&pdin<120){
    for(int i=31;i<33;i++){
      myservo.write(i);
    }
    for(int j=33;j>31;j--){
      myservo.write(j);
    }
  }
  else if(pdin>120&&pdin<170){
    for(int i=29;i<31;i++){
      myservo.write(i);
    }
    for(int j=31;j>29;j--){
      myservo.write(j);
    }
  }
  else if(pdin>170&&pdin<181){
    myservo.write(32);
  }
  if(pdin<20||pdin>179){
    digitalWrite(myRelay,LOW);
    myio=false; 
    mytime=0;   
  }
  if(myio==false&&pdin>15){
    mytime++;
    if(mytime>5){
      digitalWrite(myRelay,HIGH);
      mytime=0;
      myio=true;
    }
  }
  
  
  


}
