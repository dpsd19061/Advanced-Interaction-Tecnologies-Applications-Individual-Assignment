import processing.video.*;

Movie movie;

void setup() 
{
  size(1280, 720);
  movie = new Movie(this, "car_video.mov");
  movie.loop();
}

void movieEvent(Movie movie) 
{
  movie.read();
}

void draw() 
{
  
  float mPosition =  (mouseX*2) / (float) width;
  
  if(mouseX < 320)
  {
    mPosition = 0.5;
  }
  
  movie.speed(mPosition); 
  
  image(movie, 0, 0);
}
