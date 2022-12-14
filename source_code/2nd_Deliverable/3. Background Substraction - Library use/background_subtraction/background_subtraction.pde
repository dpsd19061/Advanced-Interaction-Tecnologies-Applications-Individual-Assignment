import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;

void setup() {
  size(1280, 720);
  
  video = new Capture(this, width, height, "pipeline:autovideosrc");
  video.start();
  
  opencv = new OpenCV(this, 1280, 720);
  opencv.startBackgroundSubtraction(5, 3, 0.5);
}

void draw() {
  image(video, 0, 0);

  if (video.width == 0 || video.height == 0)
    return;

  opencv.loadImage(video);
  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  fill(100, 0, 100, 50);
  stroke(100, 0, 100);
  strokeWeight(1);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
}

void captureEvent(Capture video) {
  video.read();
}
