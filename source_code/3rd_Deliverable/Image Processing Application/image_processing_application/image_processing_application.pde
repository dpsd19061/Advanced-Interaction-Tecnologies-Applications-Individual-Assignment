/* //<>//
 TUIO 1.1 Demo for Processing
 Copyright (c) 2005-2014 Martin Kaltenbrunner <martin@tuio.org>

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files
 (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software,
 and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float scale_factor = 1;
PFont font;

PImage img;
int imgWidth;
int imgHeight;
float zoom = 100;
float red = 255;
float green = 255;
float blue = 255;
boolean loadImg = false;

boolean verbose = true; // print console debug messages
boolean callback = true; // updates only after callbacks

void setup()
{
  // GUI setup
  //noCursor();
  size(640,360);
  //noStroke();
  //fill(0);
  
  img = loadImage("shelby.jpg");
  imgWidth = img.width;
  imgHeight = img.height;
  
  // periodic updates
  if (!callback) {
    frameRate(60); //<>//
    loop();
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial", 18);
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw()
{
  background(39, 74, 115);
  textFont(font,18*scale_factor);
    
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = tuioObjectList.get(i);
     /*stroke(0);
     fill(255,0,0);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     rotate(tobj.getAngle());
     rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
     popMatrix();
     fill(255);
     text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));*/
     if(tobj.getSymbolID() == 0){
       translate(tobj.getScreenX(width),tobj.getScreenY(height));
       rotate(tobj.getAngle());
       imageMode(CENTER);
       image(img, 0, 0, imgWidth/2, imgHeight/2);
     }
     
     if(loadImg){
       if(tobj.getSymbolID() == 1){
         zoom = constrain(zoom + tobj.getRotationSpeed() * 10, 10, 300);
         imgWidth = int(img.width* zoom/100);
         imgHeight = int(img.height * zoom/100);
       }
   
       if(tobj.getSymbolID() == 2){
         red = constrain(red + tobj.getRotationSpeed() * 10, 0, 255);
         tint(red,green,blue);
       }
       
       if(tobj.getSymbolID() == 3){
         green = constrain(green + tobj.getRotationSpeed() * 10, 0, 255);
         tint(red,green,blue);
       }
       
       if(tobj.getSymbolID() == 4){
         blue = constrain(blue + tobj.getRotationSpeed() * 10, 0, 255);
         tint(red,green,blue);
       }
     }
   }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  
  if(tobj.getSymbolID() == 0){
    loadImg = true;
  }
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  
  if(tobj.getSymbolID() == 0){
    loadImg = false;
  }
  if(tobj.getSymbolID() == 1){
    imgWidth = img.width;
    imgHeight = img.height;
  }
  if(tobj.getSymbolID() == 2){
    red = 255;
  }
  if(tobj.getSymbolID() == 3){
    green = 255;
  }
  if(tobj.getSymbolID() == 4){
    blue = 255;
  }
  
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
