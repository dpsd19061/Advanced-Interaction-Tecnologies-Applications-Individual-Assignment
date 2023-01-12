import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;
int [] userMap;
float rotation = 0;

// two AudioPlayer objects this time
Minim minim;
AudioPlayer b1;
AudioPlayer b2;
AudioPlayer b3;
AudioPlayer b4;
AudioPlayer drdaf;
AudioPlayer drhat;
AudioPlayer drsingle;
AudioPlayer drdouble;

// declare our two hotpoint objects
Hotpoint b1Trigger;
Hotpoint b2Trigger;
Hotpoint b3Trigger;
Hotpoint b4Trigger;
Hotpoint drdafTrigger;
Hotpoint drhatTrigger;
Hotpoint drsingleTrigger;
Hotpoint drdoubleTrigger;

float s = 1;

void setup() {
  size(640, 480, OPENGL);
  kinect = new SimpleOpenNI(this);
  
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(5.37999992, float(width)/float(height),cameraZ/10.0, cameraZ*10.0);
  
  if(kinect.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }                                                                                                                                           
  
  kinect.enableDepth();
  kinect.enableRGB(); 
  kinect.enableUser();
  
  kinect.alternativeViewPointDepthToImage();

  minim = new Minim(this);
  // load both audio files
  b1 = minim.loadFile("1.mp3");
  b2 = minim.loadFile("2.mp3");
  b3 = minim.loadFile("3.mp3");
  b4 = minim.loadFile("4.mp3");
  drdaf = minim.loadFile("daf.mp3");
  drhat = minim.loadFile("hat.mp3");
  drsingle = minim.loadFile("single.mp3");
  drdouble = minim.loadFile("double.mp3");
  
  
  // initialize hotpoints with their origins (x,y,z) and their size
  b1Trigger = new Hotpoint(-500, 400, 1400, 85);
  b2Trigger = new Hotpoint(-600, 200, 1400, 85);
  b3Trigger = new Hotpoint(-600, 0, 1400, 85);
  b4Trigger = new Hotpoint(-500, -200, 1400, 85);
  drdafTrigger = new Hotpoint(500, -200, 1400, 85);
  drhatTrigger = new Hotpoint(600, 0, 1400, 85);
  drsingleTrigger = new Hotpoint(600, 200, 1400, 85);
  drdoubleTrigger = new Hotpoint(500, 400, 1400, 85);
  
  background(0);
}

void draw() {
  background(0);
  kinect.update();
  
  PImage rgbImage = kinect.rgbImage(); 
  // prepare the color pixels 
  rgbImage.loadPixels();

  translate(width/2, height/2, 500);
  rotateX(radians(180));
  rotateZ(radians(180));

  translate(0, 0, 0);
  //rotateY(radians(map(mouseX, 0, width, -180, 180)));

  //translate(0, 0, s*-1000);
  //scale(s);


  stroke(255,255,255,0);

  PVector[] depthPoints = kinect.depthMapRealWorld();
  
  int[] userList = kinect.getUsers();
  if(userList.length>0)
  {
    userMap = kinect.userMap();
    // load sketches pixels
    loadPixels();
   for(int i=0; i<userMap.length; i++)
    {
      // set the sketch pixel to the color pixel
      pixels[i] = rgbImage.pixels[i];
    }
   updatePixels();
  }

  for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];

    // have each hotpoint check to see
    // if it includes the currentPoint
    b1Trigger.check(currentPoint);
    b2Trigger.check(currentPoint);
    b3Trigger.check(currentPoint);
    b4Trigger.check(currentPoint);
    drdafTrigger.check(currentPoint);
    drhatTrigger.check(currentPoint);
    drsingleTrigger.check(currentPoint);
    drdoubleTrigger.check(currentPoint);
    
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }

  //println(snareTrigger.pointsIncluded);

  if(b1Trigger.isHit()) {
    b1.play();
  }  
  
  if(!b1.isPlaying()) {
    b1.rewind();
    b1.pause();
  }

  if(b2Trigger.isHit()) {
    b2.play();
  }  
  
  if(!b2.isPlaying()) {
    b2.rewind();
    b2.pause();
  }

  if(b3Trigger.isHit()) {
    b3.play();
  }  
  
  if(!b3.isPlaying()) {
    b3.rewind();
    b3.pause();
  }
  
  if(b4Trigger.isHit()) {
    b4.play();
  }  
  
  if(!b4.isPlaying()) {
    b4.rewind();
    b4.pause();
  }

  if (drdafTrigger.isHit()) {
    drdaf.play();
  }  
  
  if(!drdaf.isPlaying()) {
    drdaf.rewind();
    drdaf.pause();
  }

  if (drhatTrigger.isHit()) {
    drhat.play();
  }  
  
  if(!drhat.isPlaying()) {
    drhat.rewind();
    drhat.pause();
  } 
  if(drsingleTrigger.isHit()) {
    drsingle.play();
  }  
  
  if(!drsingle.isPlaying()) {
    drsingle.rewind();
    drsingle.pause();
  }

  if (drdoubleTrigger.isHit()) {
    drdouble.play();
  }  
  
  if(!drdouble.isPlaying()) {
    drdouble.rewind();
    drdouble.pause();
  }

  // display each hotpoint
  // and clear its points
  b1Trigger.draw();
  b1Trigger.clear();
  
  b2Trigger.draw();
  b2Trigger.clear();
  
  b3Trigger.draw();
  b3Trigger.clear();
  
  b4Trigger.draw();
  b4Trigger.clear();
  
  drdafTrigger.draw();
  drdafTrigger.clear();
  
  drhatTrigger.draw();
  drhatTrigger.clear();
  
  drsingleTrigger.draw();
  drsingleTrigger.clear();
  
  drdoubleTrigger.draw();
  drdoubleTrigger.clear();
}

void stop()
{
  // make sure to close
  // both AudioPlayer objects
  b1.close();
  b2.close();
  b3.close();
  b4.close();
  drdaf.close();
  drhat.close();
  drsingle.close();
  drdouble.close();
  
  minim.stop();
  super.stop();
}

/*void keyPressed() {
  if (keyCode == 38) {
    s = s + 0.01;
  }
  if (keyCode == 40) {
    s = s - 0.01;
  }
}*/
