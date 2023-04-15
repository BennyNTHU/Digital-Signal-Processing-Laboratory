int pot = A0;
int val = 0;
int start_time;
int now_time;
int _min=100;
int _max=700;
int count=0; // times when min<val


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(pot,INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  start_time = micros();

  val = analogRead(pot);    //read analog input

  if (val>_max)
  {
    _max=val;
  }
  if (val<_min)
  {
    count++;
    if (count>5)
    {
      _min=val;
      count=0;
    }
  }

  val = map(val,_min,_max,0,255);    //mapping 2^n

  Serial.println(val,DEC);     //print on Matlab  

  now_time = micros();
  
  while(now_time-start_time<2000){    //sample rate 5000=200Hz 2000=500Hz 10000=100Hz 12500=80Hz  單位mus
    now_time = micros();
  }
   
}
