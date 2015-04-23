// This is the unique device id you found when registering Sparky
String device_id = "12345";  

// This is your unique token. This is for authenticating. 
// Only you (or, your token) can upload to Sparky.
// Get this by hitting the "Settings" icon on https://build.spark.io/build/
String token = "678910"; 


boolean light = false; // Toggle boolean, for our demo

void setup() {
  size(200,200);
}

void draw() {
  
  if(mousePressed && !light) { // If we press our mouse button, and the light is off (aka false, or !light)...
    
  // Here we call our spark function. The order of arguements passed to it matter! They are:
  // device_id: defined above
  // token: defined above
  // func: the function you are running. Remember it must be flashed to your spark!
  // vars: the variables passing thru to your function
  spark(device_id, token, "light_toggle", "on");
        
  println("on");
  delay(1000);
  light = true;

  } else if(mousePressed && light) {
  spark(device_id, token, "light_toggle", "off");
  
  println("off");
  delay(1000);
  light = false;
  }
  
}
