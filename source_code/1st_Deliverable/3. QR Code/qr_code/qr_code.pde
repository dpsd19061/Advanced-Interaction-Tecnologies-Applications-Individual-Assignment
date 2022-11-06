import qrcodeprocessing.*;

Decoder decoder;

//Αρχικοποίηση μιας εικόνας
PImage img;

void setup() {
  size(248, 248);
  
  decoder = new Decoder(this);
  
  //Φορτώνει Την εικόνα
  img = loadImage("dpsd19061qr.png");
  
  //Κωδικοποιεί την εικόνα
  decoder.decodeImage(img);
}

void draw() {
  //Εμφανίζει την εικόνα
  image(img, 0, 0);
}

void decoderEvent(Decoder decoder) {
  String statusMsg = decoder.getDecodedString(); 
  
  //Εκτυπώνει το URL
  println(statusMsg);
  
  //Ανοίγει το URL
  link(statusMsg);
}
