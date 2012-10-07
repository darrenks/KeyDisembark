int inputs[]={8, 9, 10, 11, 12}; //last is low bit
char   mapping[]="# aroslyepxmhgujtndcwbq?ifkz.v^<";
char mapping2[]="#\nAROSLYEPXMHGUJTNDCWBQ!IFKZ,V_<";

int been_on=0;
int shift_on=0;
int capslock_on=0;
int off_count=0;
char backspace=0xB2;
int backspace_initial_delay=200;
int backspace_repeat_delay=50;
int backspace_time=0;
int backspace_repeat=0;

void setup() {
  for(int i=0; i<5; i++) {
    pinMode(inputs[i], INPUT);
    digitalWrite(inputs[i], HIGH); //pullup
  }
  pinMode(13, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  
  make_led_green();
}

void loop() {
  int currently_on=0;
  int keys_down=0;
  for(int i=0; i<5; i++) {
    int button_down = !digitalRead(inputs[i]);
    currently_on=currently_on<<1 | button_down;
    keys_down += button_down;
  }
  
  if(currently_on==31) {
    if(backspace_time==0) {
      Keyboard.write(backspace);
      shift_on=false;
      backspace_repeat++;
    }
    if(backspace_repeat>1) {
      backspace_time=(backspace_time+1)%backspace_repeat_delay;
    } else {
      backspace_time=(backspace_time+1)%backspace_initial_delay;
    }
  }
  else {
    backspace_time=0;
    backspace_repeat=0;
  }
    
  if(been_on && !currently_on) {
    char outkey= (shift_on||capslock_on) ? mapping2[been_on] : mapping[been_on];
    if(outkey=='^') {
      shift_on=true;
      make_led_blue();
      outkey='\0';
    }
    if(outkey=='_') {
      capslock_on^=true;
      if(capslock_on) make_led_red();
      shift_on=false;
      outkey='\0';
    }
    if(outkey=='<') {
      //outkey=backspace;
      outkey='\0';
    }
    
    if(outkey!='\0') {
      Keyboard.write(outkey);
      shift_on=false;
    }
    been_on=0;
    if(!capslock_on && !shift_on) {
      make_led_green();
    }
    delay(10); //prevent multiple triggerings
  }
  else {
    been_on |= currently_on;
  }
  
  //make base led brightness proportional to number of keys down
  if(++off_count>5) off_count=0;
  digitalWrite(13, off_count<keys_down);
  
  delay(1);
}

void make_led_blue() {
  digitalWrite(2, HIGH);
  digitalWrite(3, HIGH);
  digitalWrite(4, LOW);
}

void make_led_red() {
  digitalWrite(2, LOW);
  digitalWrite(3, HIGH);
  digitalWrite(4, HIGH);
}

void make_led_green() {
  digitalWrite(2, HIGH);
  digitalWrite(3, LOW);
  digitalWrite(4, HIGH);
}
