using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

module Themes {
    enum {
        LIGHT = 0,
        DARK = 1
    }
    
    function getTheme(themeId) {
        if (themeId == LIGHT) {
            return new Light();
        } else {
            return new Dark();
        }
    }
    
	class Light {
		var dialImg;
		
		function initialize() {
			dialImg = Ui.loadResource(Rez.Drawables.lightdial);
		}
		
		function getId() {
            return LIGHT;
	    }
	    
		function dialImage() {
			return dialImg;
		}
			
		function backgroundColour() {
			return Gfx.COLOR_WHITE;
		}
		
		function timeColour() {
			return Gfx.COLOR_BLACK;
		}

		function dateColour() {
			return Gfx.COLOR_BLACK;
		}

		function sunBarColour() {
			return Gfx.COLOR_BLUE;
		}

		function timeBarColour() {
			return Gfx.COLOR_RED;
		}
	}

	class Dark {
		var dialImg;
		
		function initialize() {
			dialImg = Ui.loadResource(Rez.Drawables.darkdial);
		}
		      
        function getId() {
            return DARK;
        }
        
		function dialImage() {
			return dialImg;
		}
			
		function backgroundColour() {
			return Gfx.COLOR_BLACK;
		}
		
		function timeColour() {
			return Gfx.COLOR_WHITE;
		}

		function dateColour() {
			return Gfx.COLOR_WHITE;
		}

		function sunBarColour() {
			return Gfx.COLOR_BLUE;
		}

		function timeBarColour() {
			return Gfx.COLOR_RED;
		}
	}
}
