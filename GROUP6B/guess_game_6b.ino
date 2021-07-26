int A = 7;   //Defines all pins on the Arduino Uno board in order of connection.
int B = 6;
int C = 4;  // DOT is pin 5, not used in this example.
int D = 3;
int E = 2;
int F = 8;
int G = 9;
 
byte num0 = 0x3F;  //Hexadecimal format based upon the A-G, 0-9 Chart in excel and the wiring      // of the segment (refer to the on/off table image below).
byte num1 = 0x6;
byte num2 = 0x5B;
byte num3 = 0x4F;
byte num4 = 0x66;
byte num5 = 0x6D;
byte num6 = 0x7C;
byte num7 = 0x7;
byte num8 = 0x7F;
byte num9 = 0x6F;

byte numbers[10] = {num0, num1, num2, num3, num4, num5, num6, num7, num8, num9};

int randNum = 0;
int userNum = 0;
int score = 0;
int guesses = 0;

void setup() {
  // put your setup code here, to run once:
  pinMode(A, OUTPUT); // Making all pins outputs
  pinMode(B, OUTPUT);
  pinMode(C, OUTPUT);
  pinMode(D, OUTPUT);
  pinMode(E, OUTPUT);
  pinMode(F, OUTPUT);
  pinMode(G, OUTPUT);
  pinMode(A0,INPUT);
randomSeed(analogRead(A0));
Serial.begin(9600);
}
void showNumber(byte num){
  int result = bitRead(num, 0);  // Read the first binary entry in num and stores it in result.
 
      if (result == 1)  // Check to see if this segment should be on.
 
    {digitalWrite(A, HIGH);}   // Turns on the segment.
    else   // Otherwise, it turns it off.
    {digitalWrite(A, LOW);}  // Turns segment off.
 
      result = bitRead( num, 1);  // Same thing for the 6 remaining segments.
 
      if (result == 1)
 
    {digitalWrite(B, HIGH);}
    else
    {digitalWrite(B, LOW);}     
    result = bitRead( num, 2);
 
      if (result == 1)
 
    {digitalWrite(C, HIGH);}
    else
    {digitalWrite(C, LOW);}    
   result = bitRead( num, 3);
 
      if (result == 1)
 
    {digitalWrite(D, HIGH);}
    else
    {digitalWrite(D, LOW);}    
   result = bitRead( num, 4);
 
      if (result == 1)
    {digitalWrite(E, HIGH);}
    else
    {digitalWrite(E, LOW);}
    
   result = bitRead( num, 5);  
      if (result == 1)
    {digitalWrite(F, HIGH);}
    else
    {digitalWrite(F, LOW);}    
    
   result = bitRead( num, 6);
      if (result == 1)
    {digitalWrite(G, HIGH);}
    else
    {digitalWrite(G, LOW);}
}

void loop() {
  while(guesses < 3){
  randNum = random(0,10);
  Serial.println("Hello please guess a number 0-9");
  while(Serial.available() == 0){  // makes arduino wait for user input
  }
  
  userNum = Serial.parseInt();
  guesses = guesses + 1;
  showNumber(numbers[userNum]);
  Serial.println(userNum);
  delay(2000); // display number for 2 seconds
  if(userNum == randNum){
  Serial.println("Amazing Guess");
  score = score + 1;
  }
  else{
  Serial.print("Nope the number was  ");
  Serial.println(randNum);
  showNumber(numbers[randNum]);
    }
Serial.print("You guessed ");
Serial.print(score);
Serial.println(" out of 10");
while(Serial.available() == 0){}// makes arduino wait for user input}
userNum = Serial.parseInt();
}
}
