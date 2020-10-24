using Toybox.WatchUi;

class InputHandler extends WatchUi.InputDelegate {
	
	function initialize() {
		InputDelegate.initialize();		
	}

	function onKey( evt ) {
		
		if (evt.getType() == WatchUi.CLICK_TYPE_RELEASE && evt.getKey() == WatchUi.KEY_ENTER) {
			var activity = PhoneCommunicator.getInstance();
			switch(activity.getState()) {
				case PhoneCommunicator.BEFORE_START:
					activity.start();
					return true;
				case PhoneCommunicator.RUNNING:
					activity.pauze();
					StartStopMenu.setupMenu();
					return true;
				default:
					return false;
			}					
		}
		return false;
	}
	
	
}


class StartStopMenu extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
		var activity = PhoneCommunicator.getInstance();
		if (item.getId().equals("stop")) {
			activity.stop();
		} else if (item.getId().equals("resume")) {
			activity.resume();
		} else if (item.getId().equals("remove")) {
			activity.remove();
		} else {
			activity.stop();
		}
    	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
    
    static function setupMenu() {
        var menu = new WatchUi.Menu2({:title=>"Activity Pauzed"});

		// Add a new MenuItem to the Menu2 object
		menu.addItem(
			new WatchUi.MenuItem(
				"Resume",
				null,
				"resume",
				null
			)
		);
		
		
		menu.addItem(
			new WatchUi.MenuItem(
				"Stop",
				null,
				"stop",
				null
			)
		);		
		
		menu.addItem(
			new WatchUi.MenuItem(
				"Remove",
				null,
				"remove",
				null
			)
		);
		
		var startStopMenu = new StartStopMenu();	
		// Push the Menu2 View set up in the initializer
		WatchUi.pushView(menu, startStopMenu, WatchUi.SLIDE_IMMEDIATE);
	}

}








