#Spark Core and Processing

Working with Spark, the Spark API, and Processing is not as well documented as one might hope. Here are the steps I took to get my project working, with some helper functions and code that should apply to many more uses than my own.

You will find demo code for Processing and Spark included in the repo. Also, the p5-to-spark Processing helper function is separated out from the demo code, should you only need it!

###Setting up Spark

Follow the instructions to setup, claim, and install everything you need to work with your Spark (Sparky, henceforth).
http://docs.spark.io/connect/

###Wiring a simple Spark Demo circuit
We will make a simple, single LED toggle. 
Fritzing diagram below.
http://docs.spark.io/assets/images/breadboard-one-led.jpg

###Writing your Spark code

1. Most everything will look and function like Arduino C++ code. 
2. Let's write a simple application to allow you to toggle an LED on and off.
3. With Sparky powered on (plugged in), click the lightning bolt icon to flash it.
4. Flash is done as soon as the onboard LED goes back to pulsing cyan.

```cpp	
	int ledPin = D0;
	
	void setup() {
	    pinMode(ledPin, OUTPUT);
	    // This is how you call functions, defined below.
	    // They have a name, to call from the api, and then the function to call.
	    // I keep them the same, for sanity.
	    Spark.function("light_toggle", light_toggle);
	
	}
	
	void loop() {
	    // Nothing here for this demo, but there could be!
	}
	
	int light_toggle(String args) {
	// This is the function that will (or, correctly, CAN) be called.
	// When you make the API request to Spark, you can call any function
	// defined and flashed to your Spark. Variables are passed in as api arguments.
	// (I specify the return type int, but it's return value does not matter AFAIK.)
	
	    if(args == "on") {
	        // Spark.publish() writes to your dashboard @ https://dashboard.spark.io/
	        // Use it like you might println() in Arduino.
	        Spark.publish("Lights on!"); 
	        digitalWrite(ledPin, HIGH);
	    } else if(args == "off") {
	        Spark.publish("Lights off!");
	        digitalWrite(ledPin, LOW);
	    }
	    
	    return 1;
	}
```
	
###Writing your Processing code

1. The processing code below simply sends a light toggle request each time you click in the window.
2. It uses the helper function defined below, to send the API calls.
3. Read the comments for instructions and explanations.

```java
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
```

###Processing/Spark Helper Function
"spark_api" helper function to send requests from Processing to Spark API.

1. This helper function uses Java's RunTime to exec() the Spark API cURL request.
2. Read up on the Spark API: http://docs.spark.io/api/
3. Trust the Java part just works. Details: http://docs.oracle.com/javase/7/docs/api/java/lang/Runtime.html & http://stackoverflow.com/questions/12453477/java-using-curl-with-runtime-getruntime-exec
4. The order of the arguments must be adhered to, but it is structurally different than how you would construct the API request you might pass through cURL. Again, for sanity.

```java
	import java.io.*;
	import processing.net.*;
	
	// This is the function to run our spark api request. it accepts four variables:
	// String device_id: the unique id off the spark core
	// String token: your access token
	// String func: the name of the function we embedded in the spark core firmware
	// String vars: the variables to pass to the spark function
	
	public void spark(String device_id, String token, String func, String vars) {
	    String cmd = "curl https://api.spark.io/v1/devices/" + device_id + "/" + func + " -d access_token=" + token + " -d args=" + vars;
	    String outputString;
	
	    Process curlProc;
	    try {
	        curlProc = Runtime.getRuntime().exec(cmd);
	
	        DataInputStream curlIn = new DataInputStream(
	                curlProc.getInputStream());
	
	        while ((outputString = curlIn.readLine()) != null) {
	            System.out.println(outputString);
	        }
	
	    } catch (IOException e1) {
	        e1.printStackTrace();
	    }
	  
	};
```
	
####Passing string of multiple variables?
	
This imaginary function receives an rgb coded string argument "rrr,ggg,bbb" - eg. "240,18,34"
And uses PWM to control an RGB LED.

```java
	int tweet_led(String val) {
	
	    Spark.publish("Rendering a tweet color with value of " + val);
	    String myString = val;
	
	// Find the first comma. Index it
	    int commaIndex = myString.indexOf(',');
	
	//  Search for the next comma just after the first
	// Use the comma index to slice the received argument string
	    int secondCommaIndex = myString.indexOf(',', commaIndex+1);
	
	      currentPin = D0;
	// Slice the first 3 vals
	      String firstValue = myString.substring(0, commaIndex);       
		  int r = firstValue.toInt();
	      analogWrite(currentPin, r);
	
	      currentPin = D1;
	// Slice the second 3 vals
	      String secondValue = myString.substring(commaIndex+1, secondCommaIndex);
	      int g = secondValue.toInt();
	      analogWrite(currentPin, g);
	
	      currentPin = D2;
	// Slice the final 3 vals
	      String thirdValue = myString.substring(secondCommaIndex+1);
	      int b = thirdValue.toInt();
	      analogWrite(currentPin, b);
	    
		return 1;
 }
```
