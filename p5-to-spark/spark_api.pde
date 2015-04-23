import java.io.*;
import processing.net.*;

// This is the function to run our spark api request. it accepts four variables:
// device_id: the unique id off the spark core
// token: your access token
// func: the name of the function we embededed in the spark core firmware
// vars: the variables to pass to the spark function

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
