#include "max6675.h" 
#include <ESP8266WebServer.h>
#include <MQUnifiedsensor.h>

#include <ESP8266WiFi.h>

String apiKey ="Thingspeak-api-key";

const char *ssid = "wifi-username"; // replace with your wifi ssid and wpa2 key
const char *pass = "wifi-password";
const char* server = "api.thingspeak.com";
WiFiClient client;


      //connect buzzer and led in series with resistor

int smokeA0=A0;
float sensorValue;
int SO = D7;
int CS = D8;
int sck = D5;
MAX6675 module(sck, CS, SO);
int Analog_Input = A0;


void setup() {   
 
  Serial.begin(9600);
  delay(500);

  Serial.println("Connecting to ");
       Serial.println(ssid); 
 
       WiFi.begin(ssid, pass); 
       while (WiFi.status() != WL_CONNECTED) 
          {
            delay(500);
            Serial.print(".");
          }
      Serial.println("");
      Serial.println("WiFi connected"); 
    
}

void loop() {
const int httpPort=80;
   float temperature = module.readCelsius(); 
    sensorValue=analogRead(smokeA0);
  if (client.connect(server,httpPort))   //   "184.106.153.149" or api.thingspeak.com
                      {  
                            
                             String postStr = apiKey;
                             postStr +="&field1=";
                             postStr += String(temperature);
                             postStr +="&field2=";
                             postStr += String(sensorValue);
                             postStr += "\r\n\r\n";
 
                             client.print("POST /update HTTP/1.1\n");
                             client.print("Host: api.thingspeak.com\n");
                             client.print("Connection: close\n");
                             client.print("X-THINGSPEAKAPIKEY: "+apiKey+"\n");
                             client.print("Content-Type: application/x-www-form-urlencoded\n");
                             client.print("Content-Length: ");
                             client.print(postStr.length());
                             client.print("\n\n");
                             client.print(postStr);

                            
 
  Serial.print("\n Temperature: ");
  Serial.print(temperature);
  Serial.println(F("°C "));   
  delay(1000);
   


  //smoke = values[2];
 
  if(sensorValue > 100)
  {
    Serial.print(" | Smoke detected!");
     Serial.print("\n Smoke value :");
    Serial.print(sensorValue);
  }
  else
  {
     Serial.print(" | Smoke  not detected!");
     Serial.print("\n Smoke value :");
     Serial.print(sensorValue);
   
   
  }
                               }
          client.stop();
 
  

}
