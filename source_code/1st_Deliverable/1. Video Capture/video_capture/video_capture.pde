// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-1: Display video

// Step 1. Import the video library
import processing.video.*;

// Step 2. Declare a Capture object
Capture video;

void setup() 
{
  size(1600, 900); //Έγινε αλλαγή ανάλυσης για μεγαλύτερη εικόνα
  println(Capture.list());
  
  // Step 3. Initialize Capture object via Constructor
  // Use the default camera at 320x240 resolution
  video = new Capture(this, 1600,900, "pipeline:autovideosrc"); //Προστέθηκε το pipeline:autovideosrc έτσι ώστε να μην προκύπτουν προβλήματα (περισσότερα στην αναφορά)
  video.start();
}

// An event for when a new frame is available
void captureEvent(Capture video) 
{
  // Step 4. Read the image from the camera.
  video.read();
}

void draw() 
{
  // Step 5. Display the video image.
  image(video, 0, 0);
}
