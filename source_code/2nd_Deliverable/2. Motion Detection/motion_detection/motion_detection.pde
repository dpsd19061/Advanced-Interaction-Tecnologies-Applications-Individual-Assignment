// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-13: Simple motion detection

import processing.video.*;
// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;
// How different must a pixel be to be a "motion" pixel
float threshold = 50;

void setup() {
  size(640, 360);
  video = new Capture(this, width, height);
  video.start();
  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); // Before we read the new frame, we always save the previous frame for comparison!
  prevFrame.updatePixels();  // Read image from the camera
  video.read();
}

void draw() {

  image(video, 0, 0);
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  float xAthroisma = 0;
  float yAthroisma = 0;
  int kinoumenaPixels = 0;
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      if (diff > threshold) { 
        xAthroisma += x;
        yAthroisma += y;
        kinoumenaPixels += 1;
      }
    }
  }
  
  float xMo = xAthroisma / kinoumenaPixels; 
  float yMo = yAthroisma / kinoumenaPixels;
  
  fill(127, 36, 58);
  noStroke();
  ellipse(xMo, yMo, 20, 20);
}
