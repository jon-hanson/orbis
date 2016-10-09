package orbis;

import java.awt.*;

public interface Theme {
    static Theme light() {
        return new LightTheme();
    }

    static Theme dark() {
        return new DarkTheme();
    }

    Color backgroundColour();

    Color tickColour();

    Color hourColour();

    String fileName();

    class LightTheme implements Theme {
        @Override
        public Color backgroundColour() {
            return Color.WHITE;
        }

        @Override
        public Color tickColour() {
            return Color.BLACK;
        }

        @Override
        public Color hourColour() {
            return Device.Fenix3.Colours.DK_RED.rgb;
        }

        @Override
        public String fileName() {
            return "light_dial";
        }
    }

    class DarkTheme implements Theme {

        @Override
        public Color backgroundColour() {
            return Color.BLACK;
        }

        @Override
        public Color tickColour() {
            return Color.WHITE;
        }

        @Override
        public Color hourColour() {
            return Device.Fenix3.Colours.ORANGE.rgb;
        }

        @Override
        public String fileName() {
            return "dark_dial";
        }
    }
}
