using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as Ui;

class OrbisView extends Ui.WatchFace {

	var theme;
	
    var days = new[7];

    var polarCoords;
    var sunTimes;

    var dialHours;
    var timeFont;
	var dateFont;
	var symbolsFont;
	
    function initialize() {
        WatchFace.initialize();
        setSunTimes(Time.now());
    }

    // Load your resources here
    function onLayout(dc) {

        loadDaysOfWeek();

        polarCoords = new PolarCoords(dc.getWidth(), dc.getHeight());

        timeFont = Ui.loadResource(Rez.Fonts.time);
        dateFont = Ui.loadResource(Rez.Fonts.date);
        symbolsFont = Ui.loadResource(Rez.Fonts.symbols);

        //dialHours = new DialHours(polarCoords.centreX, polarCoords.centreY, polarCoords.radius - 8, 4, 2.0);
    }
	
	function loadDaysOfWeek() {
        days[0] = Ui.loadResource(Rez.Strings.day0);
        days[1] = Ui.loadResource(Rez.Strings.day1);
        days[2] = Ui.loadResource(Rez.Strings.day2);
        days[3] = Ui.loadResource(Rez.Strings.day3);
        days[4] = Ui.loadResource(Rez.Strings.day4);
        days[5] = Ui.loadResource(Rez.Strings.day5);
        days[6] = Ui.loadResource(Rez.Strings.day6);
	}

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    
        updateTheme();

        var nowCT = Sys.getClockTime();
        var nowM = Time.now();
		var nowInfo = Gregorian.info(nowM, Time.FORMAT_SHORT);
		
        setSunTimes(nowM);
        
        dc.setColor(Gfx.COLOR_TRANSPARENT, theme.backgroundColour());
        dc.clear();
        dc.drawBitmap(0, 0, theme.dialImage());
        
        renderTimeBars(dc, Utils.timeToDegs(nowCT));
		renderData(dc);
		renderTimeText(dc, nowInfo);
		
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    function updateTheme() {
        var themeId = App.getApp().getProperty("Theme");
        if (theme == null || theme.getId() != themeId) {
            theme = null;
            theme = Themes.getTheme(themeId);
        }
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }


    hidden function setSunTimes(now) {
        var info = Activity.getActivityInfo();
        if (info != null && info.currentLocation != null) {
            var locR = info.currentLocation.toRadians();

            var latR = locR[0];
            var lngR = locR[1];

            sunTimes = SunTimes.calculate(now, latR, lngR);
        } else if (sunTimes == null) {
            var lat = 51.457878 / 180.0 * Math.PI;
            var lng = -0.158780 / 180.0 * Math.PI;
            sunTimes = SunTimes.calculate(now, lat, lng);
        }
    }

    hidden function renderTimeBars(dc, nowTimeDegs) {

		if (sunTimes != null) {
			//Sys.println("nowTimeDegs=" + nowTimeDegs);
	        var sunriseDegs = Utils.momsToDegs(sunTimes[0]);
	        var sunsetDegs = Utils.momsToDegs(sunTimes[1]);
	
	        dc.setColor(theme.sunBarColour(), Gfx.COLOR_TRANSPARENT);
	
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius+1);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-1);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-2);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-3);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-4);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-5);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-6);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-7);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-8);
	        polarCoords.renderArc(dc, sunriseDegs, sunsetDegs, polarCoords.radius-9);
        }
        
        dc.setColor(theme.timeBarColour(), Gfx.COLOR_TRANSPARENT);
        polarCoords.renderArc(dc, 0, nowTimeDegs, polarCoords.radius-5);
        polarCoords.renderArc(dc, 0, nowTimeDegs, polarCoords.radius-6);
        polarCoords.renderArc(dc, 0, nowTimeDegs, polarCoords.radius-7);
        polarCoords.renderArc(dc, 0, nowTimeDegs, polarCoords.radius-8);
        polarCoords.renderArc(dc, 0, nowTimeDegs, polarCoords.radius-9);
    }

    const SYM_DX = 28;
    const LINE_DY = 28;
    
	function renderData(dc) {

        var y = polarCoords.centre[1] - LINE_DY - Gfx.getFontHeight(symbolsFont).toFloat() - 6;

		dc.setColor(theme.timeColour(), Gfx.COLOR_TRANSPARENT);
		dc.drawText(polarCoords.centre[0], y, symbolsFont, getBatterySymbol(), Gfx.TEXT_JUSTIFY_CENTER);
		
		var ds = Sys.getDeviceSettings();

        if (ds.phoneConnected) {
            dc.drawText(polarCoords.centre[0] - SYM_DX, y, symbolsFont, Symbols.BLUETOOTH, Gfx.TEXT_JUSTIFY_CENTER);
        }

        if (ds.notificationCount > 0) {
            var s = ds.notificationCount.toString();
            dc.drawText(polarCoords.centre[0] + SYM_DX, y, symbolsFont, Symbols.ENVELOPE, Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(polarCoords.centre[0] + SYM_DX + 12, y, Gfx.FONT_TINY, s, Gfx.TEXT_JUSTIFY_LEFT);
        }
	}

    function getBatterySymbol() {
        var battery = Sys.getSystemStats().battery.toNumber();
        var batteryI;
        if (battery >= 89) {
            batteryI = 4;
        } else if (battery >= 63) {
            batteryI = 3;
        } else if (battery >= 37) {
            batteryI = 2;
        } else if (battery >= 11) {
            batteryI = 1;
        } else {
            batteryI = 0;
        }
        
        return Symbols.BATTERY[batteryI];
    }
    
	const digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " "];
    
    function renderTimeText(dc, clockTime) {
        var h0 = clockTime.hour / 10;
        h0 = h0 == 0 ? 10 : h0; 
        var h1 =  clockTime.hour % 10;
        var m0 = clockTime.min / 10;
        var m1 =  clockTime.min % 10;

        var timeStr = clockTime.hour.format("%d") + ":" + clockTime.min.format("%02d");

        var y = polarCoords.centre[1] - Gfx.getFontHeight(timeFont).toFloat() / 2.0;

        dc.setColor(theme.timeColour(), Gfx.COLOR_TRANSPARENT);
        dc.drawText(polarCoords.centre[0], y, timeFont, timeStr, Gfx.TEXT_JUSTIFY_CENTER);

        var dayN = clockTime.day_of_week - 1;
        var date = days[dayN] + " " + clockTime.day;

        y = polarCoords.centre[1] + LINE_DY - Gfx.getFontHeight(dateFont).toFloat() / 2.0;
        dc.setColor(theme.dateColour(), Gfx.COLOR_TRANSPARENT);
        dc.drawText(polarCoords.centre[0], polarCoords.centre[1] + LINE_DY, dateFont, date, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
