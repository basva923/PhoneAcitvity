using Toybox.Communications;
using Toybox.Timer;
using Toybox.ActivityRecording;
using Toybox.Activity;



class PhoneCommunicator extends Communications.ConnectionListener { 
	static var thisObject = null;
	
	enum {
		BEFORE_START,
		RUNNING,
		PAUZED,
		STOPPED
	}
	
	var timer;
	var session;
	var succes = 0;
	var state = BEFORE_START;
	
	var listeners = [];
	
    function initialize() {
    	Communications.ConnectionListener.initialize();
    	    	
		// Communications.registerForPhoneAppMessages(method(:onPhoneMessage));
		
		Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method( :onPosition ) );
		Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_BIKECADENCE, Sensor.SENSOR_BIKESPEED, Sensor.SENSOR_TEMPERATURE] );
		
     }
     
     static function getInstance() {
     	if (thisObject == null) {
     		thisObject = new PhoneCommunicator();
     	}
     	
     	return thisObject;
     }
   
	function onPosition(info) {
		notifyNewGPSStatus(info.accuracy);
	}
		
    function onPhoneMessage(msg) {
    	notifyMessage(msg.data["command"]);
		if (msg.data["command"] == "start") {
			start();
		} else if (msg.data["command"] == "stop") {
			stop();
		} else if (msg.data["command"] == "pause") {
			pauze();
		} else if (msg.data["command"] == "resume") {
			resume();
		}
    }
    
    function sendLocationUpdate() {
    	try {
	    	
	    	var info = Activity.getActivityInfo();
	    	
	    	if (info == null || info.currentLocation == null || info.currentLocation.toDegrees().size() != 2) {
	    		notifyMessage("No gps");
	    		return;
	    	}
	    	
	    	var location = info.currentLocation.toDegrees();    	
	    	
	    	sendToPhone({
	    		"command" => "updateLocation",
	    		"params" => {
	    			"time" => info.timerTime,
					"speed" => info.currentSpeed,
					"heartRate" => info.currentHeartRate,
					"latitude" => location[0],
					"longitude" => location[1],
					"distance" => info.elapsedDistance,
					"altitude" => info.altitude,
					"cadence" => info.currentCadence
	    		}
	    	});
    	} catch (ex) {
    		notifyMessage("Failed to send");
    	}
    }
    
    function sendToPhone(msg) {
    	//System.println(msg);
    	Communications.transmit(msg, {}, self);
    }
    
    function start() {
		session = ActivityRecording.createSession({
			:name=>"CyclingSession", 
			:sport=>ActivityRecording.SPORT_CYCLING
		});
		session.start();
		state = RUNNING;
				
		timer = new Timer.Timer();
 		timer.start(method(:sendLocationUpdate), 1000, true);
    	notifyMessage("Started");
    }
    
    function pauze() {
		state = PAUZED;
		
		timer.stop();    
		session.stop();
		
    	notifyMessage("Pauzed");
    }

	function resume() {
		state = RUNNING;
		
    	notifyMessage("Resuming");
		session.start();
		
		timer = new Timer.Timer();
 		timer.start(method(:sendLocationUpdate), 1000, true);
	}
    
	function stop() {
		state = STOPPED;
		
		timer.stop();
		
		session.save();
    	notifyMessage("stopped");
	}
	
	function remove() {
		state = STOPPED;
				
		session.discard();
    	notifyMessage("Removed");
	}
    
    //! Callback when a communications operation error occurs.
	function onError() {
    	notifyMessage("Failed to send");
	}
	
	//! Callback when a communications operation completes.
	function onComplete() {
		succes += 1;
    	notifyMessage(succes.toString());
	}
	
	function notifyMessage(msg) {
		for (var i = 0; i < listeners.size(); i += 1) {
			listeners[i].onNewMessage(msg);
		}
	}
	
	function notifyNewGPSStatus(status) {
		for (var i = 0; i < listeners.size(); i += 1) {
			listeners[i].onNewGPSStatus(status);
		}
	}
	
	function getState() {
		return state;
	}
}
