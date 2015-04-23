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

// This is the function that will (or, correctly, CAN) be called.
// When you make the API request to Spark, you can call any function
// defined and flashed to your Spark. Variables are passed in as api arguements.
int light_toggle(String args) {
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
