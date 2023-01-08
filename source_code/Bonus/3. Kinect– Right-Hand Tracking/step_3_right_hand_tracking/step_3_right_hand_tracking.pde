import SimpleOpenNI.*;
SimpleOpenNI kinect;

float[] xpos = new float[50]; 
float[] ypos = new float[50];

void setup()
{
  size(640,480);
  kinect= new SimpleOpenNI(this);
  kinect.enableDepth();
  
  //turn on tracking
  kinect.enableUser();  //in older versions, this took an argument
}

void draw()
{
  kinect.update();
  PImage depth=kinect.depthImage();
  image(depth,0,0);
  
  //make vector of ints to store users
  IntVector userList = new IntVector();
  
  //write list of users
  kinect.getUsers(userList);
  
  if (userList.size()>0)
  {
    int userId = userList.get(0);
    
    if (kinect.isTrackingSkeleton(userId))
    {
      //make vector for left hand
      PVector rightHand = new PVector();
      //put position of left hand into vector
      float confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      //convert detected hand to match depth image
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
      //and display it
      
      if(confidence>0.5)
      {
        //fill(255,0,0);
        //float ellipseSize = map(convertedRightHand.z,700,2500,50,1);
        //ellipse(convertedRightHand.x, convertedRightHand.y, ellipseSize,ellipseSize);
          for (int i = 0; i < xpos.length-1; i ++ ) {
    // Shift all elements down one spot. 
    // xpos[0] = xpos[1], xpos[1] = xpos = [2], and so on. Stop at the second to last element.
    xpos[i] = xpos[i+1];
    ypos[i] = ypos[i+1];
  }
  
  // New location
  xpos[xpos.length-1] = convertedRightHand.x; // Update the last spot in the array with the mouse location.
  ypos[ypos.length-1] = convertedRightHand.y;
  
  // Draw everything
  for (int i = 0; i < xpos.length; i ++ ) {
     // Draw an ellipse for each element in the arrays. 
     // Color and size are tied to the loop's counter: i.
    noStroke();
    fill(255,0+i*5,100);
    ellipse(xpos[i],ypos[i],i,i);
  }
      }
    }
  }
}

//user tracking callbacks  //in older versions all of the callbacks below were different
void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
   
  kinect.startTrackingSkeleton(userId);
}
 
void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}
 
void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  println("onVisibleUser - userId: " + userId);
}
