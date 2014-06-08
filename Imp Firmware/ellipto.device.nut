
// ELLIPTO: Elliptical Trainer Step Counter
// Electric Imp / Keen IO demo
//
// (c) Jim Reich, May 2014
// Some code from Keen IO and Electric Imp examples and SDK
//
// This code counts steps on an elliptical trainer or exercise bike
// using a tilt sensor attached to an Electric Imp and posting to Keen IO
// Tilt sensor normally open connection pins across imp pin 1 and 3v3
// LED connected to pin 9 with a 500 ohm resistor

server.log("Started Ellipto ");

// Create hardware objects for each pin
tilt <- hardware.pin1;
led <- hardware.pin9;
vbatt <- hardware.pin5;

// configure LED for output (push-pull mode)
led.configure(DIGITAL_OUT);
vbatt.configure(ANALOG_IN);

// Global variables for step count, debounce lockout and last tilt state
counter <- 0;
ignore <- false;
tiltstate <- tilt.read();
idle <- 1;

// Trades power vs. 250 msec latency
imp.setpowersave(true);


function batt_read() {
    return format("%1.2f",1.6e-4*vbatt.read());
}

// This function is executed to unlock the step counter after a fixed
// interval has passed. It also validates the event by verifying the new
// tilt state is the same as the original tilted event and not just a 
// spurious pulse

function debounce() {
    ignore=false;
    led.write(0);
    local newtilt = tilt.read();
    if(newtilt==tiltstate) {
        if(tiltstate) {
            counter++;
            eventData <- {
                batteryVoltage = batt_read(),
                stepCount = counter
            }
            agent.send("step",eventData);
        }
    }
 }
    
// The main function that is called on each edge of the tilt sensor
// It ignores edges during the debounce lockout and also if there's no
// state change from the most recent validated event. It also turns on the
// LED which then gets turned off by the debounce
function tilted() {
    
    idle=0;

    if(!ignore) {
        local newTilt = tilt.read();
        if(newTilt != tiltstate) { // ignore if state unchanged-- noise
            ignore=true;
            imp.wakeup(0.05, debounce); 
            led.write(1); //LED on until debounce done
            tiltstate=newTilt;
        }
    }
}

// check battery hourly and post event without any steps attached
function check_batt() {

    eventData <- {
        batteryVoltage = batt_read()
    }
    agent.send("step",eventData);
    server.log("battery check");
    imp.wakeup(3600,check_batt);
}

// Wake every 10 minutes. If you're idle, sleep for a day, or until
// a tilt happens and triggers the wakeup pin. If the tilt switch is closed,
// then wakeup pin will prevent sleep, so don't try if tilt is true
// We could have slept for 30 days, but this way, we get a voltage reading daily when we wake

function sleepIfIdle()
{
    if(idle) {
        if(!tilt.read()) {
            server.log("Entering deep sleep");
            server.sleepfor(86400);
        }
        else {
            server.log("Can't sleep; Rotate crank 45 degrees to permit deep sleep for more power savings");
        }
    }
    else
    {
        idle=1;
        imp.wakeup(600,sleepIfIdle);
    }
}


// set up wakeups
tilt.configure(DIGITAL_IN_WAKEUP, tilted);
imp.wakeup(600,sleepIfIdle);
check_batt();
