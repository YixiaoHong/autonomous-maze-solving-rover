#include <Servo.h>

Servo Rwheel;
Servo Lwheel;

void setup() {


Rwheel.attach (10);
Lwheel.attach (11);
}

void loop() {

// Forward
Rwheel.writeMicroseconds(1380);
Lwheel.writeMicroseconds(1380);
delay(2500);

Rwheel.writeMicroseconds(1500);
Lwheel.writeMicroseconds(1500);
delay(2500);

Rwheel.writeMicroseconds(1599);
Lwheel.writeMicroseconds(1600);
delay(2500);

Rwheel.writeMicroseconds(1500);
Lwheel.writeMicroseconds(1500);
delay(2500);
}
