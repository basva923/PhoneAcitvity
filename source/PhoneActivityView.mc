using Toybox.WatchUi;

class PhoneActivityView extends WatchUi.View {

	var phoneCommunicator;
	
	var status;
	var gpsStatus;

    function initialize() {
        View.initialize();
        
        status = new WatchUi.Text({
            :text=>"Open the app",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });        
        gpsStatus = new WatchUi.Text({
            :text=>"No gps",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_XTINY,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP + WatchUi.LAYOUT_HALIGN_CENTER / 2,
        });
        
        phoneCommunicator = PhoneCommunicator.getInstance();
        phoneCommunicator.listeners.add(self);
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.clear();
        
        status.draw(dc);
        gpsStatus.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    function onNewMessage(msg) {
    	status.setText(msg);
    	WatchUi.requestUpdate();
    }
    
    function onNewGPSStatus(status) {
    	switch (status) {
    		case Position.QUALITY_NOT_AVAILABLE:
    			gpsStatus.setText("No gps");
    			break;
    		case Position.QUALITY_LAST_KNOWN:
    			gpsStatus.setText("Last known");
    			break;
    		case Position.QUALITY_POOR:
    			gpsStatus.setText("Poor");
    			break;
    		case Position.QUALITY_USABLE:
    			gpsStatus.setText("Usable");
    			break;
    		case Position.QUALITY_GOOD:
    			gpsStatus.setText("Good");
    			break;
    	}
    	WatchUi.requestUpdate();
    }

}
