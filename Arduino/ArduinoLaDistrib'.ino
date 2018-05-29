#include <SoftwareSerial.h>

/* CONSTANTES */
// PIN KEY
#define LEDPIN        13

#define M1_ENABLE_PIN 7 //pwm
#define M1_IN1_PIN    31
#define M1_IN2_PIN    30
 
#define M2_ENABLE_PIN  6 //pwm
#define M2_IN1_PIN     33
#define M2_IN2_PIN     32

// MOTOR KEYs
#define SVLOW 64 // Speed
#define SLOW 127
#define SHIGH 191
#define SVHIGH 255
#define DELAYms 1000 // time

#define INITIALSTOCK  12
#define NBFEATURES    7

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

int stock[NBFEATURES]; 
int nbPaper = 0;

void setup() {

   //init Serials
   Serial.begin(9600);
   Serial2.begin(9600);

   // init leds
   pinMode(LEDPIN, OUTPUT);
   digitalWrite(LEDPIN, LOW);
   //on initialise les pins du moteur 1
  pinMode(M1_IN1_PIN, OUTPUT);
  pinMode(M1_IN2_PIN, OUTPUT);
  pinMode(M1_ENABLE_PIN, OUTPUT);
 
  //on initialise les pins du moteur 2
  pinMode(M2_IN1_PIN, OUTPUT);
  pinMode(M2_IN2_PIN, OUTPUT);
  pinMode(M2_ENABLE_PIN, OUTPUT);

   // init des stocks
   for(int i=0 ; i<NBFEATURES; i++){
    stock[i] = INITIALSTOCK;
   }
}
 
void loop(){

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
      dataFromBt = String();
      if(nbPaper != 0) {
        int speed = SHIGH;
        SetMotor1(speed, true);
        SetMotor2(speed, true);
        delay(DELAYms*nbPaper);
        speed = 0;
        nbPaper = 0;
        SetMotor1(speed, true);
        SetMotor2(speed, true);
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
    if(nbPurchased != 0) {
      if(rank == 0) {
        nbPaper = nbPurchased;
      }
      stock[rank] -= nbPurchased; 
      nbPurchased = 0;
    }
    
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
