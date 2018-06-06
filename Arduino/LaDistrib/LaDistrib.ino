#include <SoftwareSerial.h>
#include <LiquidCrystal.h>

/* CONSTANTES */
// PIN LED KEY
#define LEDPININK      34
#define LEDPINBICBLUE  44
#define LEDPINBICRED   40
#define LEDPINBICGREEN 38
#define LEDPINBICBLACK 42
#define LEDPINPENCIL   36

// PIN LCD KEY
#define RSPIN 35
#define EPIN  37
#define BUS5  39
#define BUS4  41
#define BUS3  43
#define BUS2  45

// PIN MOTOR KEY
#define M1_ENABLE_PIN 7 //pwm
#define M1_IN1_PIN    31
#define M1_IN2_PIN    30
 
#define M2_ENABLE_PIN  6 //pwm
#define M2_IN1_PIN     33
#define M2_IN2_PIN     32

// MOTOR KEYs
#define SVLOW 64 // Speed
#define SLOW 127
#define SHIGH 205
#define SVHIGH 255
#define DELAYms 1000 // time

#define INITIALSTOCK  50
#define NBFEATURES    7
#define DELAYLEDSms 2500

// Message Keys
#define SEPARATORKEY    'A'
#define BUYFEATUREKEY   'B'
#define STOCKREQUESTKEY 'D'
#define NUMSEPARATORKEY 'N'
#define ENDKEY          'Z'

//ID Feature
#define IDPAPER     '0' 
#define IDBLUEPEN   '1'
#define IDBLACKPEN  '2'
#define IDGREENPEN  '3'
#define IDREDPEN    '4'
#define IDINK       '5'
#define IDPENCIL    '6'

/* VARIABLES */

String dataFromBt = String();
LiquidCrystal lcd(RSPIN, EPIN, BUS5, BUS4, BUS3, BUS2);

int stock[NBFEATURES];
int led[NBFEATURES] = {0};
int nbPaper = 0;

void setup() {

   //init Serials
   Serial.begin(9600);
   Serial2.begin(9600);

   // init leds
   pinMode(LEDPININK, OUTPUT);
   digitalWrite(LEDPININK, LOW);
   pinMode(LEDPINBICBLUE, OUTPUT);
   digitalWrite(LEDPINBICBLUE, LOW);
   pinMode(LEDPINBICRED, OUTPUT);
   digitalWrite(LEDPINBICRED, LOW);
   pinMode(LEDPINBICGREEN, OUTPUT);
   digitalWrite(LEDPINBICGREEN, LOW);
   pinMode(LEDPINBICBLACK, OUTPUT);
   digitalWrite(LEDPINBICBLACK, LOW);
   pinMode(LEDPINPENCIL, OUTPUT);
   digitalWrite(LEDPINPENCIL, LOW);
   
   //on initialise les pins du moteur 1
   pinMode(M1_IN1_PIN, OUTPUT);
   pinMode(M1_IN2_PIN, OUTPUT);
   pinMode(M1_ENABLE_PIN, OUTPUT);
 
   //on initialise les pins du moteur 2
   pinMode(M2_IN1_PIN, OUTPUT);
   pinMode(M2_IN2_PIN, OUTPUT);
   pinMode(M2_ENABLE_PIN, OUTPUT);

   //init LCD
   lcd.begin(16, 2);
   
   // init des stocks
   for(int i=0 ; i<NBFEATURES; i++){
    stock[i] = i+INITIALSTOCK;
   }
}
 
void loop(){

    //lcd.print("GROS");
    if (Serial2.available()) {
        dataFromBt += (char)Serial2.read();
        Serial.println(dataFromBt);
        
    } else if (Serial.available()) {
      Serial2.write(Serial.read());
    } 

    // Gestion des stock
    if ( dataFromBt[0] == STOCKREQUESTKEY && lastCharacter(dataFromBt) == ENDKEY) {
        String strToSend = disponibilities();
        dataFromBt = String();
        Serial.print(strToSend);
        Serial2.print(strToSend);
        
    } else if (dataFromBt[0] == BUYFEATUREKEY && lastCharacter(dataFromBt) == ENDKEY) {
      buy();
      switchOnLeds();
      dataFromBt = String();
      
      if(nbPaper != 0) {
        switchOnMotors(true, true, SVHIGH);
        switchOffMotors();
        /*int speed = 0;
        SetMotor1(speed, true);
        SetMotor2(speed, true);
        delay(DELAYms*nbPaper);
        delay(1000);
        speed = 0;
        nbPaper = 0;
        SetMotor1(speed, true);
        SetMotor2(speed, true);*/
      }
    }
}

//Renvoie le dernier caractere d'une chaine de char
char lastCharacter(String data) {
  char character = char();

  for(int i = 0; i<data.length() ; i++) {
    if(i == data.length()-1) {
      character  = data[i];
    }
  }
  
  return character;
}

// Permet de définir a quoi correspond la donnée présente
bool isId(char characterTested) {

  if(characterTested == SEPARATORKEY || characterTested == STOCKREQUESTKEY || characterTested == ENDKEY){
    return false;
  } else {
    return true;
  }
}

bool isNumber(char characterTested) {
  switch (characterTested) { 
  case '0':
    return true;
  case '1':
    return true;
  case '2':
    return true;
  case '3':
    return true;
  case '4':
    return true;
  case '5':
    return true;
  case '6':
    return true;
  case '7':
    return true;
  case '8':
    return true;
  case '9':
    return true;
  default: 
    return false;
  }
}
// Lit la requete de demande de stock et transmet une réponse
String disponibilities() {
  String strToSend = String(STOCKREQUESTKEY);
  
  for(int i=0 ; i<dataFromBt.length() ; i++) {
      if(isId(dataFromBt[i])) {
        int rank = String(dataFromBt[i]).toInt();
        strToSend += SEPARATORKEY + String(stock[rank]);
      }
  }

  strToSend += ENDKEY;
  dataFromBt = String();
  return strToSend;
}

void buy() {
  String str = String();
  int rank = 0;
  int nbPurchased = 0;
  for(int i = 0; i<dataFromBt.length(); i++){
    if (isNumber(dataFromBt[i])) {
      int ant = i-1;
      
      if (dataFromBt[ant] == SEPARATORKEY) {
        
        rank = String(dataFromBt[i]).toInt();
        Serial.print(rank);
      } else if(dataFromBt[ant] == NUMSEPARATORKEY) {
        nbPurchased = String(dataFromBt[i]).toInt();
        Serial.print(nbPurchased);
      }
    }
    /*if(nbPurchased != 0) {
      if(rank == 0) {
        nbPaper = nbPurchased;
      }
      stock[rank] -= nbPurchased; 
      nbPurchased = 0;
    }*/
    if(nbPurchased != 0) {
      led[rank] = nbPurchased;
      stock[rank] -= nbPurchased; 
      nbPurchased = 0;
    }
  }
}

// alume toutes les leds 
void switchOnLeds() {
  nbPaper = led[0];
  
  for(int i = 1; i<NBFEATURES; i++) {
    if(led[i] != 0) {
      switch (led[i]) {
        case 1:
        digitalWrite(LEDPINBICBLUE, HIGH);
        break;
        case 2:
        digitalWrite(LEDPINBICBLACK, HIGH);
        break;
        case 3:
        digitalWrite(LEDPINBICGREEN, HIGH);
        break;
        case 4:
        digitalWrite(LEDPINBICRED, HIGH);
        break;
        case 5:
        digitalWrite(LEDPININK, HIGH);
        break;
        case 6:
        digitalWrite(LEDPINPENCIL, HIGH);
        break;
        default:
        break;
      }
    }
  }
  resetLedArray();
  delay(DELAYLEDSms);
  switchOffAllLed();
}

// Reset a 0 le nb de feature achetée
void resetLedArray() {
  for(int i=0 ; i<NBFEATURES ; i++){
    led[i] = 0;
  }
}

//Fonction qui set le moteur1
void SetMotor1(int speed, boolean reverse)
{
  analogWrite(M1_ENABLE_PIN, speed);
  digitalWrite(M1_IN1_PIN, ! reverse);
  digitalWrite(M1_IN2_PIN, reverse);
}
 
//Fonction qui set le moteur2
void SetMotor2(int speed, boolean reverse)
{
  analogWrite(M2_ENABLE_PIN, speed);
  digitalWrite(M2_IN1_PIN, ! reverse);
  digitalWrite(M2_IN2_PIN, reverse);
}

// éteint une seul led
void switchOffLed(int keyLed){
  digitalWrite(keyLed, LOW);
}

//éteint toute les led
void switchOffAllLed() {
  for(int i = LEDPININK ; i<= LEDPINBICBLUE; i+=2) {
    digitalWrite(i, LOW);
  }
}

void switchOnMotors(bool motor1_On, bool motor2_On, int speed) {

  if (motor1_On) {
    SetMotor1(speed, true);
  }
  if (motor2_On) {
    SetMotor2(speed, true);
  }
  delay(DELAYms*nbPaper);
  
}

void switchOffMotors() {
  int speed = 0;
  nbPaper = 0;
  SetMotor1(speed, true);
  SetMotor2(speed, true);
}

